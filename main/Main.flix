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

use Core/Io/File.{File, new => newFile, readLines, writeLines,mkdirs,exists};
use GetOpt.{ArgDescr, OptionDescr};
use GetOpt.ArgDescr.{NoArg, ReqArg, OptArg};
use GetOpt.ArgOrder.{RequireOrder, Permute, ReturnInOrder};
use GetOpt.{getOpt, usageInfo};
use Core/Io/IOError.IOError;
use Core/Io/File.File.File;
use Pkger.{isValidProject,initPackage,uninstallPackage,mkPackage,makejar,packFlix};


enum Flag {
    case Version
    case Help
}


instance ToString[Flag]{
    def toString(x: Flag): String = match x {
        case Version => "Version"
    }}

instance Eq[Flag]{
    def eq(x: Flag, y: Flag): Bool = match (x,y){
        case (Version, Version) => true
        //case (Help,Help) => true
    }
    def neq(x:Flag, y:Flag) : Bool = false
}
def options(): List[OptionDescr[Flag]] = 
    {optionIds = 'v' :: Nil, optionNames = "Version" :: Nil, argDescriptor = NoArg(Version), explanation = "prints the version number"} ::
    {optionIds = 'h' :: Nil, optionNames = "Help" :: Nil, argDescriptor = NoArg(Help), explanation = "Show the commands"} :: Nil
   


def handleOptions(x: List[Flag]): Result[Bool,String] & Impure = 
    let flipVersion = "The current version is 0,1,0";
    match List.head(x) {
        case Some(Version) => "Welcome to Flip" |> println; flipVersion |> println; Ok(true)
        case Some(Help) => 
        "Flip [init] [noArgs]"|> println;
        "Flip [new] [packagename]" |> println;
        "Flip [uninstall] [packagename]"|> println;
        "Flip [checkvalid] [noArgs]"|> println;
        "Flip [findflix] [dirName]"|> println; Ok(true)
        case _ => Ok(false)
    }

def handleNonOption(x: List[String]): Result[Bool,String] & Impure = 
    match x {
        case Nil => Ok(false)
        case n :: rest => 
            match n {
                case "pack" => let fileName = List.head(rest); packFlix(fileName);Ok(true)
                case "new" => let fileName = List.head(rest); mkPackage(fileName);Ok(true)
                case "uninstall" => let fileName = List.head(rest); uninstallPackage(fileName);Ok(true)
                case "init" => initPackage();Ok(true)
                case "checkvalid" => "Hi" |> println;isValidProject();Ok(true)
                case "makejar" => makejar();Ok(true)
                case _ => Ok(false)
            }
    }


def main(args: Array[String]): Int32 & Impure =
    let args2 = GetOpt.preprocess({quoteOpen = "'", quoteClose = "'", stripQuoteMarks = false}, args);  
    let header = "Usage: <program> [OPTION...] files...";
    let options1 = options();
    match getOpt(Permute,options1,args2){
        case Success(opts) => {
            //Console.printLine("Optionals: ${opts.options}");
            //Console.printLine("Non-optionals: ${opts.nonOptions}");
            handleOptions(opts.options);
            handleNonOption(opts.nonOptions); 0}
        case Failure(errs) => {Console.printLine("Errors: ${errs}");  Console.printLine(usageInfo(header, options1)); 1}
    }



