//
//  Constants.swift
//  Jetpal
//
//  Created by Alexandr on 10/19/18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

//MARK: - URLS
let BASE_URL = "https://jetpalchattyapp.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
//MARK: - Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"

//MARK: - UserDefaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
