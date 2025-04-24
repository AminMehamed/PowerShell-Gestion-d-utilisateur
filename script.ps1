Write-Host "Creation And Modification Script"

while ($true){
      Write-Host "`n1. Modifier un utilisateur"
      Write-Host "2. Creer un utilisateur par-default"
      Write-Host "3. Créer un utilisateur"
      Write-Host "4.desactive/active une account"
      Write-Host "5. supprimer une account"
      Write-Host "0. Quitter"
      $choice = Read-Host "Veuillez choisir une option"


      switch ($choice){
            "1" {


            }

            "2"{
                  while ($true){
                        Write-Host "Press -1 to quite"
                        $n = Read-Host "Enter le nom d'utilisateur"
                        if($n -eq "-1"){
                              break
                        }
                        elseif (Get-LocalUser -Name $n -ErrorAction SilentlyContinue){
                                 Write-Host "Nom d’utilisateur Existe déjà"
                        }else{
                              $p = Read-Host "Enter une password" -AsSecureString

                             if(New-LocalUser -Name $n -Password $p){
                                 Write-Host "User is created successfully"
                              }else{
                                    Write-Host "Something wrong try again!!!,Open file as adminstrateur and try again"
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
                        $n = Read-Host "Enter le nom d'utilisateur"
                        if (Get-LocalUser -Name $n -ErrorAction SilentlyContinue){
                              Write-Host "Nom d’utilisateur Existe déjà"
                        }else{
                              $choice2 = Read-Host "Do you want password?(any key would be considred yes) O/N"
                              if(($choice2.ToLower()) -eq "non" -or ($Choice2.ToLower() -eq "n")){
                                    New-LocalUser -Name $n -NoPassword
                                    break
                              }
                             #pass expires....
                              $Pass = Read-Host "Enter password" -AsSecureString
                              New-LocalUser -Name $n -Password $Pass
                              Write-Host "pressing any key other than n would be considred yes"
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
                                          Write-Host "User $n is Created sussessfully"
                                          break
                                    }else{
                                          Write-Host "Something went Wrong, Run script Again"
                                          break
                                    }

                              }catch{
                                    Write-Host "Erreur!!!, Contact Admin"

                              }
                              




                        }
                  }

            }

           "4" {
            Write-Host "Press -1 to quite"
            while ($true){
                  $n = Read-Host "Enter le nome d'uitilisateur"
                  if(Get-LocalUser -Name $n -ErrorAction SilentlyContinue){
                        Write-Host "Press A to Active"
                        Write-Host "Press D to Desactive"
                        Write-Host "Press -1 to quite"
                        $choice = Read-Host "Enter you choice"
                        for ($i =1 ; $i -lt 4; $i++){
                              if ($choice.ToLower() -eq "a"){
                                    Enable-LocalUser -Name $n
                                    Write-Host "Account Activated successfully"
                                    break
                              }
                              elseif($choice.ToLower() -eq "d"){
                                    Disable-LocalUser -Name $n
                                    Write-Host "Acount Desabled Successfully"
                                    break
                              }
                              elseif($choice -eq "-1"){
                                    Write-Host "Quitting..."
                                    break
                              }
                              else{
                                    Write-Host "Invalid Choice, Try Again..."
                              }

                        }

                  }
                  elseif ($n -eq "-1"){
                        break
                        
                  }
                  else{
                        Write-Host "User doesnt exist try again"
                  }

            }

            }

            "5"{
                  
            }

            "0" {break}
            default {Write-Host "Choix invalide. Reessayez."}
      }
}