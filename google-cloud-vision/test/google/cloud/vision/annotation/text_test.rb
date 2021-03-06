# Copyright 2016 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "helper"

describe Google::Cloud::Vision::Annotation::Text, :mock_vision do
  # Run through JSON to turn all keys to strings...
  let(:grpc_list) { text_annotation_responses }
  let(:text) { Google::Cloud::Vision::Annotation::Text.from_grpc grpc_list }

  it "knows the given attributes" do
    text.text.must_include "Google Cloud Client for Ruby"
    text.locale.must_equal "en"
    text.words.count.must_equal 28
    text.words[0].text.must_equal "Google"
    text.words[0].bounds.map(&:to_a).must_equal [[13, 8], [53, 8], [53, 23], [13, 23]]
    text.words[27].text.must_equal "Storage."
    text.words[27].bounds.map(&:to_a).must_equal [[304, 59], [351, 59], [351, 74], [304, 74]]
  end

  it "can convert to a hash" do
    hash = text.to_h
    hash.must_be_kind_of Hash
    hash[:text].must_equal text.text
    hash[:locale].must_equal text.locale
    hash[:bounds].must_be_kind_of Array
    hash[:bounds][0].must_equal({ x: 1,   y: 0 })
    hash[:bounds][1].must_equal({ x: 295, y: 0 })
    hash[:bounds][2].must_equal({ x: 295, y: 301 })
    hash[:bounds][3].must_equal({ x: 1,   y: 301 })
    hash[:words].count.must_equal text.words.count
  end

  it "can convert to a string" do
    text.to_s.must_equal "Google Cloud Client for Ruby an idiomatic, intuitive, and\nnatural way for Ruby developers to integrate with Google Cloud\nPlatform services, like Cloud Datastore and Cloud Storage.\n"
    text.inspect.must_include text.to_s.inspect
  end
end
