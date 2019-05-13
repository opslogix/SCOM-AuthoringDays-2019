          param($strSourceID,$strManagedEntityID,$strPrincipalName, $strSpoolerServiceName)

          $oAPI = new-object -comObject "MOM.ScriptAPI"
          $Discovery = $oAPI.CreateDiscoveryData(0, $strSourceID, $strManagedEntityID)

          $KeyExists = Test-Path "HKLM:SYSTEM\CurrentControlSet\Control\Print\Printers"

          if($KeyExists -eq "True")
          {

              $Keys = Get-ChildItem HKLM:SYSTEM\CurrentControlSet\Control\Print\Printers
              $Items = $Keys | Foreach-Object {Get-ItemProperty $_.PsPath }

              ForEach ($Item in $Items) {
              $printerName = $Item.PSChildName
              $path = "HKLM:SYSTEM\CurrentControlSet\Control\Print\Printers\" + $printerName
              $PrinterDriver = (Get-ItemProperty -path $path).'Printer Driver'
              
              $Instance = $Discovery.CreateClassInstance("$MPElement[Name='PrintMonitor.Class.Printer']$")
              $Instance.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$", $strPrincipalName)
              $Instance.AddProperty("$MPElement[Name='PrintMonitor.Class.Spooler']/ServiceName$", $strSpoolerServiceName)
              $Instance.AddProperty("$MPElement[Name='PrintMonitor.Class.Printer']/PrinterName$", $PrinterName)
              $Instance.AddProperty("$MPElement[Name='PrintMonitor.Class.Printer']/DriverName$", $PrinterDriver)
              $Discovery.AddInstance($Instance)
              
              }

              
          }

          $Discovery
		  # besure end the script with a empty row!
