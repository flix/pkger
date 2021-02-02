/*
 * Copyright 2021 Magnus Madsen
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

namespace Pkger {

    /////////////////////////////////////////////////////////////////////////////
    // initProject                                                             //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testInitProject01(): Bool & Impure = 
        initProject(newFile("abc"));     
        true

    /////////////////////////////////////////////////////////////////////////////
    //  compare                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def testCompare01(): Bool = 
        compare(SemVer(1,2,3),SemVer(1,2,3)) == true
    
    @test 
    def testCompare02(): Bool = 
        compare(SemVer(1,2,3),SemVer(0,0,0)) == true

    @test 
    def testCompare03(): Bool = 
        compare(SemVer(1,2,3),SemVer(2,0,0)) == false
    
    @test 
    def testCompare04(): Bool = 
        compare(SemVer(1,2,3),SemVer(1,3,0)) == false
    
    @test 
    def testCompare05(): Bool = 
        compare(SemVer(1,2,3),SemVer(1,2,4)) == false
    
    @test 
    def testCompare06(): Bool = 
        compare(SemVer(0,2,3),SemVer(1,0,0)) == false
    
    @test 
    def testCompare07(): Bool = 
        compare(SemVer(100,2,3),SemVer(99,0,0)) == true
    
    @test 
    def testCompare08(): Bool = 
        compare(SemVer(0,0,2),SemVer(0,0,1)) == true
    
    @test 
    def testCompare09(): Bool = 
        compare(SemVer(0,999,2),SemVer(1,0,1)) == false
    
    @test 
    def testCompare010(): Bool = 
        compare(SemVer(1000,10000,2),SemVer(1000,10001,1)) == false


}


