Write-Host "Creation And Modification Script"
$exitt = $true
while ($exitt){
      Write-Host "`n1. Modifier un utilisateur"
      Write-Host "2. Creer un utilisateur (simple))"
      Write-Host "3. Créer un utilisateur"
      Write-Host "4.desactive/active une account"
      Write-Host "5. supprimer une account"
      Write-Host "6. Get list of Users"
      Write-Host "0. Quitter"
      $choice = Read-Host "Veuillez choisir une option"
      if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            Write-Host "This script requires administrator privileges. Please run as administrator." -ForegroundColor Red
            exit
        }


      switch ($choice){
            "1" {
                  write-Host "press -1 to quite"
                  while ($true){
                        $n = Read-Host "Enter the name of the user"
                        if ($n -eq "-1"){break}
                        elseif (Get-LocalUser -Name $n -ErrorAction SilentlyContinue ){
                              for ($i =0; $i -lt 4; $i ++){
                                    Write-Host "------Menu de modifucation-------"
                                    Write-Host "1.Change Password"
                                    Write-Host "2.User can change password"
                                    Write-Host "3.Password Expires"
                                    Write-Host "4.Change FullName"
                                    Write-Host "5.Change User Description"
                                    Write-Host "-1.Quitte" -ForegroundColor Yellow
                                    Write-Host "----------------------------------"
                                    $Mchoice = Read-Host "Enter your choice"
                                    #add switch option instead of if statments
                                    switch ($Mchoice) {
                                          "-1"{
                                                $i = 5
                                                break
                                                
                                          }

                                          "1" {
                                                $NewP = Read-Host "Enter New Password" -AsSecureString
                                                Set-LocalUser -Name $n -Password $NewP 
                                                Write-Host "Password changed successfully" -ForegroundColor Green
                                                      
                                          }
                                          "2" {
                                                Write-Host "--------------------------------"
                                                Write-Host "1.User Can Change password" -ForegroundColor Green
                                                Write-Host "2.User can not change password" -ForegroundColor Yellow
                                                Write-Host "--------------------------------"
                                                $Uchoice = Read-Host "Enter your choice"
                                                if($Uchoice -eq "1"){
                                                      $username = $n
                                                      $user = [ADSI]"WinNT://$env:COMPUTERNAME/$username,user"
                                                      $user.UserFlags = $user.UserFlags.Value -band (-bnot 0x40)
                                                      $user.SetInfo()
                                                      Write-Host "L'utilisateur $username peut maintenant changer son mot de passe."
                                                }
                                                elseif ($Uchoice -eq "2"){
                                                      # Replace 'UserNameHere' with the actual username
                                                      $username = $n
                                                      # Get the local user using ADSI
                                                      $user = [ADSI]"WinNT://$env:COMPUTERNAME/$username,user"
                                                      # Add the 'User Cannot Change Password' flag
                                                      $user.UserFlags = $user.UserFlags.Value -bor 0x40  # 0x40 = UF_PASSWD_CANT_CHANGE
                                                      $user.SetInfo()

                                                      Write-Host "L'utilisateur $username ne peut plus changer son mot de passe."
                                                }
                                                else{
                                                      Write-Host "Invalid choice..." -ForegroundColor Red
                                                }
                                          }
                                          "3"{
                                                Write-Host "--------------------------------"
                                                Write-Host "1.Password Expires" -ForegroundColor Yellow
                                                Write-Host "2.Password doesnt Expire" -ForegroundColor Green
                                                Write-Host "--------------------------------"
                                                $Echoice = Read-Host "Enter your choice"

                                                if($Echoice -eq "1"){
                                                      Set-LocalUser -Name $n -PasswordNeverExpires:$false
                                                      Write-Host "Password Expires" -ForegroundColor Green
                                                }
                                                elseif ($Echoice -eq "2"){
                                                      Set-LocalUser -Name $n -PasswordNeverExpires:$true
                                                      Write-Host "Password doesnt Expire" -ForegroundColor Green
                                                }
                                                else{
                                                      Write-Host "Invalid choice..." -ForegroundColor Red
                                                }
                                          }
                                          "4"{
                                                for ($i=1 ; $i -lt 4;$i++){
                                                      $FullN = Read-Host "Enter New Full Name"
                                                      if ([string]::IsNullOrWhiteSpace($FullN)) {
                                                            Write-Host "Full Name cannot be empty" -ForegroundColor Red
                                                            Write-Host "$i/3 rest" -ForegroundColor Yellow
                                                            continue
                                                        }
                                                      elseif ($FullN -match '[\/\\[\]:;|=,+*?<>"]') {
                                                            Write-Host "Full Name contains invalid characters" -ForegroundColor Red
                                                            Write-Host "$i/3 rest" -ForegroundColor Yellow
                                                            continue
                                                        }else{
                                                            Set-LocalUser -Name $n -FullName $FullN
                                                            Write-Host "FullName changed successfully" -ForegroundColor Green
                                                            break

                                                        }
                                                      

                                                }
                                          }
                                          "5"{
                                                $d = Read-Host "Enter description"
                                                try {
                                                      Set-LocalUser -Name $n -Description $d
                                                      Write-Host "Success" -ForegroundColor Green
                                                }catch{
                                                      Write-Host "Erreur!!!" -ForegroundColor Red
                                                }
                                          }

                                          }
                                          
                              }
                              

                        }else{Write-Host "User Doesnt Exist" -ForegroundColor Red}

                  }


            }

            "2"{
                  while ($true){
                        Write-Host "Press -1 to quite"
                        $n = Read-Host "Enter le nom d'utilisateur"
                        if ([string]::IsNullOrWhiteSpace($n)) {
                              Write-Host "Username cannot be empty" -ForegroundColor Red
                              continue
                          }
                        elseif ($n -match '[\/\\[\]:;|=,+*?<>"]') {
                              Write-Host "Username contains invalid characters" -ForegroundColor Red
                              continue
                          }
                        elseif($n -eq "-1"){
                              break
                        }
                        elseif (Get-LocalUser -Name $n -ErrorAction SilentlyContinue){
                                 Write-Host "Nom d’utilisateur Existe déjà" -ForegroundColor Yellow
                        }else{
                              $p = Read-Host "Enter une password" -AsSecureString

                             if(New-LocalUser -Name $n -Password $p){
                                 Write-Host "User is created successfully" -ForegroundColor Green
                              }else{
                                    Write-Host "Something wrong try again!!!,Open file as adminstrateur and try again" -ForegroundColor Red
                                      }

                              if ($n -eq "-1"){
                                    Write-Host "Quitting"
                                    break
                              }
                              break
                        }
                        
                  }


            }

            "3"{
                  while ($true){
                        Write-Host "Press -1 to quite"
                        Write-Host "For adding a a description and fullname to the User you can go to mudification after finishing creating the account" -ForegroundColor Cyan
                        $n = Read-Host "Enter le nom d'utilisateur"
                        if ([string]::IsNullOrWhiteSpace($n)) {
                              Write-Host "Username cannot be empty" -ForegroundColor Red
                              continue
                          }
                        elseif ($n -match '[\/\\[\]:;|=,+*?<>"]') {
                              Write-Host "Username contains invalid characters" -ForegroundColor Red
                              continue
                          }
                        elseif (Get-LocalUser -Name $n -ErrorAction SilentlyContinue){
                              Write-Host "Nom d’utilisateur Existe déjà" -ForegroundColor DarkBlue
                        }else{
                              $choice2 = Read-Host "Do you want password?(any key would be considred yes) O/N"
                              if(($choice2.ToLower()) -eq "non" -or ($Choice2.ToLower() -eq "n")){
                                    New-LocalUser -Name $n -NoPassword
                                    Write-Host "User is Created Successfully" -ForegroundColor Green
                                    break
                              }
                             #pass expires....
                              $Pass = Read-Host "Enter password" -AsSecureString
                              New-LocalUser -Name $n -Password $Pass
                              Write-Host "pressing any key other than n would be considred yes" -ForegroundColor Yellow
                              $choice3 = Read-Host "Do you want the user to be able to change his password O/N"
                              if ($choice3.ToLower() -eq "n" -or $choice3.ToLower() -eq "non"){
                                    Set-LocalUser -Name $n -UserMayNotChangePassword $true

                              }
                              $choice4 = Read-Host "Do you Want a password that expires? O/N"
                              if ($choice4.ToLower() -eq "n" -or $choice4.ToLower() -eq "non"){
                                    Set-LocalUser -Name $n -PasswordNeverExpires $true
                              }
                              
                              try{
                                    if (Get-LocalUser -Name $n ){
                                          Write-Host "User $n is Created sussessfully" -ForegroundColor Green
                                          break
                                    }else{
                                          Write-Host "Something went Wrong, Run script Again" -ForegroundColor Red
                                          break
                                    }

                              }catch{
                                    Write-Host "Erreur!!!, Contact Admin" -ForegroundColor Red

                              }
                              




                        }
                  }

            }

           "4" {
            Write-Host "Press -1 to quite"
            while ($true){
                  $n = Read-Host "Enter le nome d'uitilisateur"
                  if(Get-LocalUser -Name $n -ErrorAction SilentlyContinue){
                       
                        for ($i =1 ; $i -lt 4; $i++){
                              Write-Host "------------------"
                              Write-Host "Press A to Active"
                              Write-Host "Press D to Desactive"
                              Write-Host "Press -1 to quite"
                              Write-Host "--------------------"
                              $choice = Read-Host "Enter your choice"
                              if ($choice.ToLower() -eq "a"){
                                    Enable-LocalUser -Name $n
                                    Write-Host "Account Activated successfully" -ForegroundColor Green
                                    $i = 0
                                    break
                              }
                              elseif($choice.ToLower() -eq "d"){
                                    Disable-LocalUser -Name $n
                                    Write-Host "Acount Desabled Successfully" -ForegroundColor Green
                                    $i = 0
                                    break
                              }
                              elseif($choice -eq "-1"){
                                    Write-Host "Quitting..." -ForegroundColor Yellow
                                    break
                              }
                              else{
                                    Write-Host "-------------------------------"
                                    Write-Host "Invalid Choice, Try Again...⚠️" -ForegroundColor Red
                                    Write-Host  "$i/3 trys left🚨🚨 "
                                    Write-Host "-------------------------------"
                              }

                        }

                  }
                  elseif ($n -eq "-1"){
                        break
                        
                  }
                  else{
                        Write-Host "User doesnt exist try again" -ForegroundColor Yellow
                  }

            }

            }

            "5"{
                  Write-Host "Press -1 to quite"
                  while ($true){
                        $n = Read-Host "Enter le nome d'uitilisateur"
                        if(Get-LocalUser -Name $n -ErrorAction SilentlyContinue){
                              Remove-LocalUser -Name $n
                              Write-Host "User is Deleted Successfully" -ForegroundColor Green
                              break
                        }
                        elseif($n -eq "-1"){
                              break
                        }
                        else{
                              Write-Host "User Doesnt Exist,Try again" -ForegroundColor Yellow
                        }  
                  }
                 
            }
            "6"{
                  $exit = $false
                  while (-not $exit) {
                        #We have to fix this later...
                        Write-Host "It may not show any users in the first time, so try 3 time for exact result" -ForegroundColor Yellow
                        Write-Host "----------------------------"
                        Write-Host "1.Show all users"
                        Write-Host "2.Show a spesific User"
                        Write-Host "-1.Quitte" -ForegroundColor Yellow
                        Write-Host "-------------------------------"
                        $choice = Read-Host "Enter your choice"
                        switch ($choice){
                              "1"{
                                    #WE have to add error checking
                                    Write-Host "Getting list of users..." -ForegroundColor Green
                                    $users = Get-LocalUser 
                                    Write-Host "Users Loaded: $($users.Count)🧑‍🦰" -ForegroundColor Cyan
                                    Get-LocalUser 
                              }
                              "2"{
                                    $n = Read-Host "Enter the name of the user"
                                    if (Get-LocalUser -Name $n -ErrorAction SilentlyContinue){
                                          Write-Host "User exists" -ForegroundColor Green
                                          Get-LocalUser -Name $n
                                          
                                          
                                    }
                                    elseif($n -eq ""){
                                          Write-Host "User cant be null" -ForegroundColor Red
                                    }
                                    else{
                                          if (Get-LocalUser -Name "$($n[0])*" -ErrorAction SilentlyContinue){
                                                Write-Host "its workin $($n[0])"
                                                Write-Host "We couldnt find any user with name $n,So these are the users that their name start with the same letter" -ForegroundColor Green
                                                $Lusers = Get-LocalUser -Name "$($n[0])*"
                                                Write-Host "Users Loaded: $($Lusers.Count)"
                                                Get-LocalUser -Name "$($n[0])*"
                                                
                                                }
                                          else{
                                                Write-Host "We Coudnt find any Users...😥"

                                          }
                                    }

                              }

                              "-1"{
                                    Write-Output "Quitting... " -ForegroundColor Yellow
                                    $exit = $true
                              }

                              default { Write-Host "Invalid choice try again " -ForegroundColor Red}
                        }
                  }6
            }

            "0" {$exitt = $false}
            default {Write-Host "Choix invalide. Reessayez." -ForegroundColor Yellow}
      }
}