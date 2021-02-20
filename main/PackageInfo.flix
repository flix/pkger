/*
 * Copyright 2021 Magnus Madsen
 * Copyright 2021 Zhiwei Zeng
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

use SemVer.SemVer;
use Pkger/Author.Author;
use Pkger/Dependency.PackageDependency;

namespace PackageInfo{
 // Any field that's only require by the registry is ignore for now
    pub enum PackageInfo{
        case PackageInfo({
            name : String,
            version : SemVer,
            authors : List[Author],
            edition : SemVer,
            dependencies : List[PackageDependency],
            url : String
        })
    }
 }