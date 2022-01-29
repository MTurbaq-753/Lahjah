//
//  ViewController.swift
//  Dialect Arabia
//
//  Created by Mohammad Alturbaq on 24/12/2021.
//

import UIKit
import Firebase
import SideMenu
import GoogleMobileAds

class ViewController: UIViewController{
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-8394868531265727/3995351683"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()

    
    @IBOutlet weak var adView: UIView!
    
    @IBOutlet weak var rightMenuButton: UIButton!
    
    @IBOutlet weak var leftMenuButton: UIButton!
    
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    @IBOutlet weak var SearchButton: UIButton!
    
    @IBOutlet weak var AddWordButton: UIButton!
    
    
    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    
    @IBOutlet weak var languageButtonView: UIView!
    
    @IBOutlet weak var languagePicker: UIPickerView!
    
    @IBOutlet weak var languageView: UIView!
    
    var searchValue: String?
    
    var menu : SideMenuNavigationController?
    


//MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        LoginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        LoginButton.titleLabel?.minimumScaleFactor = 0.5
        
        banner.rootViewController = self
        adView.addSubview(banner)
        do{
            K.AppCurrentLanguage = try String(contentsOf: K.LanguageURL)
            K.currentLanguage = AppConfig.SystemLanguage[K.AppCurrentLanguage] as! ResultConfig
            changeUILanguage()
        }
        catch {
            print(error.localizedDescription)
            K.currentLanguage = AppConfig.SystemLanguage[K.systemLanguages[0]] as! ResultConfig
            K.AppCurrentLanguage = K.systemLanguages[0]
            do {
                try K.AppCurrentLanguage.write(to: K.LanguageURL, atomically: true, encoding: .utf8)
            }
            catch{
                print("Couldn't write to file")
            }
            changeUILanguage()
        }
        do{
            K.User = try String(contentsOf: K.UserURL)
            if K.User != "user"{
                self.didLogin()
            }
            else{
                LogoutButton.isHidden = true
            }
        }
        catch {
            print(error.localizedDescription)
            LogoutButton.isHidden = true

        }
        languageButton.setTitle(K.currentLanguage.LanguageButton, for: .normal)
        
        

        SearchBar.delegate = self
        languagePicker.delegate = self
        
        languagePicker.isHidden = true        

        
        
        languagePicker.selectRow(K.LanguageRow[K.AppCurrentLanguage]!, inComponent: 0, animated: true)

        
        // Do any additional setup after loading the view.
        self.SearchBar.barTintColor = UIColor.init(red: 0.067, green: 0.153, blue: 0.290, alpha: 1)
        self.SearchBar.searchTextField.textColor = .white
        
        //Keyboard dismiss when clicked on background
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = CGRect(x: 0, y: 0, width: adView.frame.size.width, height: adView.frame.size.height).integral
    }
    

//MARK: - Search
    @IBAction func SearchPressed(_ sender: UIButton) {

        self.searchValue = self.SearchBar.text

        self.performSegue(withIdentifier: K.GoToScroll, sender: self)
        
    }
    
    //MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == K.GoToScroll{
            let destinationVC = segue.destination as! WordsList
            destinationVC.val = searchValue
        }
        if segue.identifier == K.GoToAddWord{
            let destinationVC = segue.destination as! AddWord
            if SearchBar.text!.isEmpty{
                destinationVC.word = ""
            }
            else{
                destinationVC.word = SearchBar.text
            }
        }
        if segue.identifier == K.GoToLogin{
            let destinationVC = segue.destination as! Login
            destinationVC.delegate = self
        }
        
        if segue.identifier == K.GoToRegister{
            let destinationVC = segue.destination as! Register
            destinationVC.delegate = self
        }
    }
    
    //MARK: - LogClicks
    @IBAction func LoginClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.GoToLogin, sender: self)
        
    }
    
    
    @IBAction func LogoutClicked(_ sender: Any) {

        do {try Auth.auth().signOut()
            K.User = "user"
            do {
                try K.User.write(to: K.UserURL, atomically: true, encoding: .utf8)
            }
            catch{
                print("Couldn't write to file")
            }
            LoginButton.isHidden = false
            LogoutButton.isHidden = true
        }
        catch let e as NSError{
            print("Error signingout. \(e)")
        }

        changeUILanguage()
    }
    
    //MARK: - Language
    @IBAction func LanguageClicked(_ sender: Any) {
        Auth.auth().currentUser?.reload(completion: { e in
        })
        print(Auth.auth().currentUser?.isEmailVerified)
        if languagePicker.isHidden{
            
            languageButton.setTitle("", for: .normal)
            languageButton.setImage(UIImage.init(systemName: "checkmark"), for: .normal)
            
            languagePicker.alpha = 0
            languagePicker.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.languagePicker.alpha = 1
            }

        }else{
            
            K.AppCurrentLanguage = K.systemLanguages[languagePicker.selectedRow(inComponent: 0)]
            do {
                try K.AppCurrentLanguage.write(to: K.LanguageURL, atomically: true, encoding: .utf8)
            }
            catch{
                print("Couldn't write to file")
            }
            K.currentLanguage = AppConfig.SystemLanguage[K.AppCurrentLanguage] as! ResultConfig
                        
            self.changeUILanguage()
            languageButton.setImage(UIImage(systemName: "globe"), for: .normal)
            
        UIView.animate(withDuration: 0.3, animations: {
            self.languagePicker.alpha = 0
        }) { (finished) in
            self.languagePicker.isHidden = finished
        }
        }
    }
    
    //MARK: - ChangeUI
    func changeUILanguage(){
        
        menu = SideMenuNavigationController(rootViewController: MenuController())

        
        
        if K.AppCurrentLanguage == "Arabic"{
            leftMenuButton.isHidden = true
            rightMenuButton.isHidden = false
            SideMenuManager.default.rightMenuNavigationController = menu
            SideMenuManager.default.leftMenuNavigationController = nil

        }
        else {
            rightMenuButton.isHidden = true
            leftMenuButton.isHidden = false
            SideMenuManager.default.leftMenuNavigationController = menu
            SideMenuManager.default.rightMenuNavigationController = nil
        }
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.view )
        
        self.RegisterButton.setTitle(K.currentLanguage.RegisterButton, for: .normal)
        
        if LoginButton.titleLabel?.text == K.LogButtonText[0]{
            LoginButton.setTitle(K.currentLanguage.LoginButton![0], for: .normal)
        }
        if LogoutButton.titleLabel?.text == K.LogButtonText[1]{
            LogoutButton.setTitle(K.currentLanguage.LoginButton![1], for: .normal)
        }
        
        K.LogButtonText = K.currentLanguage.LoginButton!
        self.AddWordButton.setTitle(K.currentLanguage.AddWordButton, for: .normal)
        self.SearchButton.setTitle(K.currentLanguage.ViewWords, for: .normal)
        languageButton.setTitle(K.currentLanguage.LanguageButton, for: .normal)
        
    }
    
    
//MARK: - Menu Clicked
    @IBAction func menuButtonClicked(_ sender: Any) {
        
        present(menu!, animated: true, completion: nil)
        
    }
    
    }


    
extension ViewController: UISearchBarDelegate{
    
    //Keyboard dismiss when clicked on background
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        SearchBar.resignFirstResponder()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SearchPressed(SearchButton)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Make a delay here, so the suggetions will not keept showing and slow down the user's device?
//        let data = Data(searchBar.text!)
//        let sorted = data.sort(text: searchBar.text!)
//        print(sorted)
        print(searchText)
        if searchText == ""{SearchButton.setTitle(K.currentLanguage.ViewWords, for: .normal)}
        else{SearchButton.setTitle(K.currentLanguage.SearchButton, for: .normal)}
        }
    
    
}


extension ViewController: LoginDelegate, RegisterDelegate{
    func didLogin() {
        print("GGGG")
        LoginButton.isHidden = true
        LogoutButton.isHidden = false
        changeUILanguage()
    }
    func didRegister() {
        print("RRRRR")
        LoginButton.isHidden = true
        LogoutButton.isHidden = false
        changeUILanguage()
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        K.systemLanguages.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: String(K.systemLanguages[row]), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
          }
    
}

//MARK: - Menu Controller
class MenuController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MenuCell.nib(), forCellReuseIdentifier: K.MenuCell)
        tableView.backgroundColor = UIColor.init(red: 0.027, green: 0.078, blue: 0.235, alpha: 1)
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.init(named: "LogoColor")
        navBarAppearance.shadowImage = nil // line
        navBarAppearance.shadowColor = nil // line
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).standardAppearance = navBarAppearance
        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).scrollEdgeAppearance = navBarAppearance



    }
    
    var items = ["English" : [K.User, "Added meanings", "Upvoted", "Reset Password", "My links"], "Arabic" : [K.User, "المعاني المضافة", "المعاني التي تم تفضيلها", "إعادة تعيين كلمة المرور", "روابط"]]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items["English"]!.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let MenuCell = tableView.dequeueReusableCell(withIdentifier: K.MenuCell, for: indexPath) as? MenuCell{
            
            if K.AppCurrentLanguage == "Arabic"{
                MenuCell.arLabel.text! = items["Arabic"]![indexPath.item]
                MenuCell.engLabel.isHidden = true
            }
            else{
                MenuCell.engLabel.text! = items["English"]![indexPath.item]
                MenuCell.arLabel.isHidden = true
            }
            if K.User == "user" && indexPath.item == 0{
                MenuCell.arLabel.text = ""
                MenuCell.engLabel.text = ""
            }
            cell = MenuCell
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = UIStoryboard(name: "Main", bundle: Bundle.main)
        if indexPath.item == 1{
            let destinationVC = main.instantiateViewController(withIdentifier: K.GoToAddedMeanings) as? AddedMeanings
            navigationController?.isToolbarHidden = true
            navigationController?.pushViewController(destinationVC!, animated: true)
        }
        
        if indexPath.item == 2{
            let destinationVC = main.instantiateViewController(withIdentifier: K.GoToUpvoted) as? Upvoted
            navigationController?.pushViewController(destinationVC!, animated: true)
        }
        
        
        if indexPath.item == 3{
            let destinationVC = main.instantiateViewController(withIdentifier: K.GoToReset) as? ResetPassword
            
            navigationController?.pushViewController(destinationVC!, animated: true)
            
            
        }
        if indexPath.item == 4{
            let destinationVC = main.instantiateViewController(withIdentifier: K.GoToLinks) as? MyLinks
            navigationController?.pushViewController(destinationVC!, animated: true)
        }
    }
    
}

