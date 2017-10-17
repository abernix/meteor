# For now, we only have one script.
$jUnit = Join-Path $env:TEMP 'self-test-junit-0.xml'

$tests = @(
  'modules - test app'
  '^assets'
  'autoupdate'
  'create$'
  # 'dynamic import'
  'colons'
) -Join '|'

Write-Host "Running: $tests" -ForegroundColor Yellow
Write-Host "Excluded: $env:SELF_TEST_EXCLUDE" -ForegroundColor Yellow

.\meteor.bat self-test --junit "$jUnit" "$tests" --exclude "$env:SELF_TEST_EXCLUDE" '2>&1'
$selfTestExitCode = $LASTEXITCODE

If ($selfTestExitCode -eq 0) {
  Write-Host "Success!" -ForegroundColor Green
} else {
  Write-Host "FAILURE! (Exit: $selfTestExitCode)" -ForegroundColor Red
}

Write-Host "Uploading JUnit test results..." -ForegroundColor Magenta
$wc = New-Object 'System.Net.WebClient'
Get-ChildItem $env:TEMP 'self-test-junit-*.xml' | Foreach-Object {
  $wc.UploadFile("https://ci.appveyor.com/api/testresults/junit/$($env:APPVEYOR_JOB_ID)", ($_.FullName))
}

If ($selfTestExitCode -ne 0) {
  Exit $selfTestExitCode
}
