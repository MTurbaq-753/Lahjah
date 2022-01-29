//
//  Language.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 09/01/2022.
//

import Foundation

class AppConfig{
    
    
    public static let SystemLanguage = [
        "Arabic" :
            ResultConfig(BackButton: "رجوع", RegisterButton: "تسجيل", verifyButton: "توثيق", LoginButton: ["تسجيل دخول","تسجيل خروج"], AddWordButton: "إضافة كلمة", SearchButton: "بحث",ViewWords: "استعراض", LanguageButton: "Arabic|العربية", ArabicMeaning: "المعنى بالعربية", EnglishMeaning: "المعنى بالانجليزية (اختياري)", SubmitButton: "تنفيذ", UpvoteButtonLabel: "إعجاب", DownvoteButtonLabel: "عدم إعجاب", Error: "خطأ", E_EngExampleWithNoMeaning: "قم بإدخال معنى باللغة الانجليزية", E_AddNeededInputs: "قم بإضافة جميع الخانات الالزامية", E_WrongEmail: "البريد الالكتروني غير صحيح", E_LoginNeeded: "تسجيل الدخول مطلوب", OK: "حسنًا", None: "لا يوجد"),
        "English" :
            ResultConfig(BackButton: "Back", RegisterButton: "Register", verifyButton: "Verify", LoginButton: ["Login", "Logout"], AddWordButton: "Add Word", SearchButton: "Search",ViewWords: "View",  LanguageButton: "English|الانجليزية", ArabicMeaning: "Arabic Meaning", EnglishMeaning: "English Meaning (Optional)", SubmitButton: "Submit", UpvoteButtonLabel: "Upvote", DownvoteButtonLabel: "Downvote", Error: "Error", E_EngExampleWithNoMeaning: "Add english meaning", E_AddNeededInputs: "Add all mandatory fields", E_WrongEmail: "Wrong Email", E_LoginNeeded: "Login Needed", OK: "OK", None: "None")
        ] as [String : Any]
    
 
}

struct ResultConfig{
    let BackButton : String?
    let RegisterButton : String?
    let verifyButton: String?
    let LoginButton : [String]?
    let AddWordButton : String?
    let SearchButton : String?
    let ViewWords : String?
    let LanguageButton : String?
    let ArabicMeaning : String?
    let EnglishMeaning : String?
    let SubmitButton : String?
    let UpvoteButtonLabel : String?
    let DownvoteButtonLabel : String?
    let Error: String
    let E_EngExampleWithNoMeaning: String
    let E_AddNeededInputs: String
    let E_WrongEmail: String
    let E_LoginNeeded: String
    let OK: String
    let None: String
}


//        //NavigationController
//        "BackButton" : "رجوع",
//        //View Controller
//        "RegisterButton" : "تسجيل",
//        "LoginButton" : ["تسجيل دخول", "تسجيل خروج"],
//        "AddWordButton" : "إضافة كلمة",
//        "SearchButton" : "بحث",
//        //Register Controller
//            //"EmailLabel" : "Email",
//            //"PasswordLabel" : "Password"
//        //Login Controller
//            //"EmailLabel" : "
//            //"PasswordLabel" : "Password"
//        //WordsList Controller
//        //MeaningResults Controller
//        //AddWord Controller
//        "ArabicMeaning(Mandatory)" : "المعنى بالعربية (إجباري)",
//        "EnglishMeaning(Optional)" : "المعنى بالانجليزية (اختياري)",
//        "SubmitButton" : "تنفيذ",
//        //ReusableCell .xib
//        "UpvoteButtonLabel" : "إعجاب",
//        "DownvoteButtonLabel" : "عدم إعجاب",

//"English" : [
//  //NavigationController
//  "BackButton" : "Back",
//  //View Controller
//  "RegisterButton" : "Register",
//  "LoginButton" : ["Login", "Logout"],
//  "AddWordButton" : "Add Word",
//  "SearchButton" : "Search",
//  //Register Controller
//      //"EmailLabel" : "Email",
//      //"PasswordLabel" : "Password"
//  //Login Controller
//      //"EmailLabel" : "
//      //"PasswordLabel" : "Password"
//  //WordsList Controller
//  //MeaningResults Controller
//  //AddWord Controller
//  "ArabicMeaning(Mandatory)" : "Arabic Meaning (Mandatory)",
//  "EnglishMeaning(Optional)" : "English Meaning (Optional)",
//  "SubmitButton" : "Submit",
//  //ReusableCell .xib
//  "UpvoteButtonLabel" : "Upvote",
//  "DownvoteButtonLabel" : "Downvote",
//]
