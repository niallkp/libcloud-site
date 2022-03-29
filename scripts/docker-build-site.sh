#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

IMAGE_NAME="libcloud-site-dev"

docker build --build-arg UID="$(id -u)" --build-arg GID="$(id -g)" -f Dockerfile -t "${IMAGE_NAME}" . --progress=plain
docker run --rm -v "$(pwd)":/home/jekyll/site -it "${IMAGE_NAME}" bash -l -c "pushd source; bundle exec jekyll build; popd; ./scripts/optimize-images.sh"

rsync -vurt --delete --exclude=".git/" --exclude="*.log" source/_site/* output/
rm -rf source/_site
cp source/.htaccess output/.htaccess
