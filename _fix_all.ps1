$ErrorActionPreference = "Stop"
$t=[System.IO.File]::ReadAllText((Resolve-Path 'index.html'),[System.Text.Encoding]::UTF8);

# 1. Replace scan function
$startScan = $t.IndexOf('function scan(file){');
$startBtn = $t.IndexOf('btnCam.addEventListener');
if($startScan -lt 0 -or $startBtn -lt 0){ throw "scan or btnCam not found" }
$oldScan = $t.Substring($startScan, $startBtn - $startScan);
$newScan = [System.IO.File]::ReadAllText((Resolve-Path '_scan_fixed.txt'),[System.Text.Encoding]::UTF8);
$t = $t.Replace($oldScan, $newScan);
"scan replaced OK"

# 2. Replace showResult (find next function after showResult)
$startSR = $t.IndexOf('function showResult(list, conf, all, errMsg){');
$startScan2 = $t.IndexOf('function scan(file){', $startSR);
if($startSR -lt 0 -or $startScan2 -lt 0){ throw "showResult or scan not found" }
$oldSR = $t.Substring($startSR, $startScan2 - $startSR);
$newSR = [System.IO.File]::ReadAllText((Resolve-Path '_showResult_fixed.txt'),[System.Text.Encoding]::UTF8);
$t = $t.Replace($oldSR, $newSR);
"showResult replaced OK"

[System.IO.File]::WriteAllText((Resolve-Path 'index.html'),$t,[System.Text.Encoding]::UTF8);
"All done - both replacements saved"
