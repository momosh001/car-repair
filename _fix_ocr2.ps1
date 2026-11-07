$ErrorActionPreference = "Stop"
$t=[System.IO.File]::ReadAllText((Resolve-Path 'index.html'),[System.Text.Encoding]::UTF8);

# Fix scan function first
$startScan = $t.IndexOf('function scan(file){');
$startBtn = $t.IndexOf('btnCam.addEventListener');
if($startScan -lt 0 -or $startBtn -lt 0){ throw "scan or btnCam not found: Scan=$startScan Btn=$startBtn" }
$oldScan = $t.Substring($startScan, $startBtn - $startScan);
$newScan = [System.IO.File]::ReadAllText((Resolve-Path '_scan_fixed.txt'),[System.Text.Encoding]::UTF8);
$t = $t.Replace($oldScan, $newScan);
"scan replaced OK"

# Fix showResult - recalculate positions after scan replacement
$startSR = $t.IndexOf('function showResult(list, conf, all, errMsg){');
$startSO = $t.IndexOf('function showOverlay');
if($startSR -lt 0 -or $startSO -lt 0){ throw "showResult or showOverlay not found: SR=$startSR SO=$startSO" }
$oldSR = $t.Substring($startSR, $startSO - $startSR);
$newSR = [System.IO.File]::ReadAllText((Resolve-Path '_showResult_fixed.txt'),[System.Text.Encoding]::UTF8);
$t = $t.Replace($oldSR, $newSR);
"showResult replaced OK"

[System.IO.File]::WriteAllText((Resolve-Path 'index.html'),$t,[System.Text.Encoding]::UTF8);
"All done"
