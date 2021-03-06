# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module ArrowDataset
  class InMemoryScanTask
    alias_method :initialize_raw, :initialize
    private :initialize_raw
    def initialize(record_batches, **options)
      record_batches = record_batches.collect do |record_batch|
        unless record_batch.is_a?(Arrow::RecordBatch)
          record_batch = Arrow::RecordBatch.new(record_batch)
        end
        record_batch
      end
      context = options.delete(:context) || ScanContext.new
      options[:schema] ||= record_batches.first.schema
      fragment = options.delete(:fragment)
      fragment ||= InMemoryFragment.new(options[:schema], record_batches)
      initialize_raw(record_batches, options, context, fragment)
    end
  end
end
