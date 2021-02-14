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

use Core/Io/File.{new => newFile};
use SemVer.SemVer.SemVer;
use SemVer.lessEqual;
namespace Pkger {

    /////////////////////////////////////////////////////////////////////////////
    // initProject                                                             //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testInitProject01(): Bool & Impure = 
        initProject(newFile("abc"));     
        true

    /////////////////////////////////////////////////////////////////////////////
    //  lessEqual                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testlessEqual01(): Bool = 
        lessEqual(SemVer(1, 2, 3),SemVer(1, 2, 3)) == true
    
    @test 
    def testlessEqual02(): Bool = 
        lessEqual(SemVer(1, 2, 3),SemVer(0, 0, 0)) == true

    @test 
    def testlessEqual03(): Bool = 
        lessEqual(SemVer(1, 2, 3),SemVer(2, 0, 0)) == false
    
    @test 
    def testlessEqual04(): Bool = 
        lessEqual(SemVer(1, 2, 3),SemVer(1, 3, 0)) == false
    
    @test 
    def testlessEqual05(): Bool = 
        lessEqual(SemVer(1, 2, 3),SemVer(1, 2, 4)) == false
    
    @test 
    def testlessEqual06(): Bool = 
        lessEqual(SemVer(0, 2, 3),SemVer(1, 0, 0)) == false
    
    @test 
    def testlessEqual07(): Bool = 
        lessEqual(SemVer(100, 2, 3),SemVer(99, 0, 0)) == true
    
    @test 
    def testlessEqual08(): Bool = 
        lessEqual(SemVer(0, 0, 2),SemVer(0, 0, 1)) == true
    
    @test 
    def testlessEqual09(): Bool = 
        lessEqual(SemVer(0, 999, 2),SemVer(1, 0, 1)) == false
    
    @test 
    def testlessEqual010(): Bool = 
        lessEqual(SemVer(1000, 10000, 2),SemVer(1000, 10001, 1)) == false

    @test 
    def testlessEqual011(): Bool = 
        lessEqual(SemVer(1000, 10000, 2),SemVer(1000, 10, 1)) == true

     @test 
    def testlessEqual012(): Bool = 
        lessEqual(SemVer(0, 2, 2),SemVer(0, 1, 90)) == true


}


