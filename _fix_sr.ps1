$ErrorActionPreference = "Stop"
$t=[System.IO.File]::ReadAllText((Resolve-Path 'index.html'),[System.Text.Encoding]::UTF8);

$startSR = $t.IndexOf('function showResult(list, conf, all, errMsg){');
$startScan = $t.IndexOf('function scan(file){', $startSR);
if($startSR -lt 0 -or $startScan -lt 0){ throw "showResult or scan not found: SR=$startSR Scan=$startScan" }
$oldSR = $t.Substring($startSR, $startScan - $startSR);
$newSR = [System.IO.File]::ReadAllText((Resolve-Path '_showResult_fixed.txt'),[System.Text.Encoding]::UTF8);
$t = $t.Replace($oldSR, $newSR);
[System.IO.File]::WriteAllText((Resolve-Path 'index.html'),$t,[System.Text.Encoding]::UTF8);
"showResult replaced OK"
