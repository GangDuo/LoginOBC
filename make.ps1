$user = read-host Enter OBCiD
$password = read-host Enter password -AsSecureString

# セキュア文字列を複合して平文にします
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
$pass  = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)


 
# ヒアドキュメント（変数を展開する）
$str_here_document = @"
var global = {
  "documentCompleted": true
};

(function() {
  var IE = WScript.CreateObject( "InternetExplorer.Application", "ie_" ),
      timeout = 60000, // milliseconds
      time1;

  IE.Visible = true;
  IE.Navigate("https://id.obc.jp/kyplxd7repk0/");
  global.documentCompleted = false;
  while(!global.documentCompleted)
  {
      WScript.Sleep(10);
  }

  IE.Document.getElementById('OBCID').value = "$user";
  IE.Document.getElementById("checkAuthPolisyBtn").click();

  time1 = new Date();
  while((IE.Document.getElementById("login") === null)
     && ((new Date() - time1) < timeout)) {
    WScript.Sleep(10);
  }
  IE.Document.getElementById('Password').value = "$pass";
  IE.Document.getElementById("login").click();
  WScript.Quit();
})();

function ie_DocumentComplete()
{
    global.documentCompleted = true;
}
"@
 
$fullName = "LoginOBC.js"
# 標準出力に表示
# Write-Host $str_here_document
$str_here_document > $fullName
Start-Process -FilePath 'C:\Program Files\Windows Script Encoder\screnc.exe' -ArgumentList LoginOBC.js,LoginOBC.jse -Wait
Remove-Item LoginOBC.js
