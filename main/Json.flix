/*
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
use Pkger/PackageInfo.PackageInfo;
use Pkger/PackageInfo.PackageInfo.PackageInfo;
use Pkger/Examples.examplePackage2;
use Pkger/SemVer.SemVer.SemVer;
use Pkger/SemVer.SemVer;
use Pkger/Author.Author;
use Pkger/Author.Author.Author;
use Pkger/Dependency.PackageDependency.PackageDependency;
use Pkger/Dependency.PackageDependency;


namespace Pkger{
    namespace JSON{
        /// pub enum JSON_WHITESPACE{
        ///     case " "
        /// }


        //
        // Parse JSON format string into a PackageInfo
        //
        pub def parse(_json: String): PackageInfo = 
            PackageInfo({
            name = "MyPackageNameTwo",
            version = SemVer(2,0,0), 
            authors = Author({name = "Jens", email = None, website = None}) :: Nil,
            edition = SemVer(0,14,6),
            dependencies = Nil,
            url = "Nil"})
        
        pub def lex(s: String, tokens: List[String]): List[String] & Impure= 
            let stringList = String.toList(s);
            match stringList {
                case Nil => tokens 
                case n :: rest =>
                    match Char.toString(n) {
                        case " " => let restStringList = List.map(Char.toString,rest);
                                    let newstring = String.flatten(restStringList);
                                    lex(newstring,tokens)
                        case "{" => let restStringList = List.map(Char.toString,rest);
                                    let newstring = String.flatten(restStringList);
                                    let tokens = tokens ::: ("{"::Nil);
                                    lex(newstring,tokens)
                        case _ => tokens
                    }
            }
                
            


        pub def stringifyPackageInfo(_p: PackageInfo): String = 
            //let PackageInfo(name, version, authors, edition, dependencies, url) = p;
            "name"
        
        //
        // Turn semver into a string 
        //    
        pub def stringifySemver(sv: SemVer): String  = 
            let SemVer(a,b,c) = sv;
            "(" + Int32.toString(a)+"," + Int32.toString(b) + ","+ Int32.toString(c)+")"

        //
        //Turn authors into a string 
        //
        pub def stringifyAuthors(authors: List[Author]): String = 
            let authorStringList = List.formatWith(makeAuthorString, "," , authors);
            authorStringList 

        def makeAuthorString(a: Author): String = 
            let Author(authorRecord) = a;
            let email = match authorRecord.email {
                case None => "None"
                case Some(y) => y
            };
            let website = match authorRecord.website {
                case None => "None"
                case Some(y) => y
            };
            let author = 
                String.lineSeparator()+Char.toString('"')+"name"+Char.toString('"') + ":" + Char.toString('"')+authorRecord.name+Char.toString('"')+"," + 
                String.lineSeparator()+Char.toString('"')+"email"+Char.toString('"') + ":" + Char.toString('"')+email+Char.toString('"')+"," +
                String.lineSeparator()+Char.toString('"')+"website"+Char.toString('"') + ":" + Char.toString('"')+website+Char.toString('"');
            let authorIndent = "{"+String.indent(3,author)+"}";
            authorIndent
        
        //
        // Turn dependencies into a string 
        //
        pub def stringifyDependency(dependencies: List[PackageDependency]): String = 
            let authorStringList = List.formatWith(makeDependencyString,",",dependencies);
            authorStringList
        
        def makeDependencyString(a: PackageDependency): String = 
            let PackageDependency(packageRecord) = a;
            let name = packageRecord.name;
            let version = stringifySemver(packageRecord.version);
            let dependency = 
                String.lineSeparator()+Char.toString('"')+"packagename"+Char.toString('"') + ":" + Char.toString('"')+name+Char.toString('"')+"," + 
                String.lineSeparator()+Char.toString('"')+"packagversion"+Char.toString('"') + ":" + Char.toString('"')+version+Char.toString('"');
            let dependencyIndent = "{"+String.indent(3,dependency)+"}";
            dependencyIndent

    }    
}
