$jUnit = Join-Path $env:TEMP 'self-test-junit-0.xml'

$testList = @(
  'modules - test app'
  'autoupdate'
  'create$'
  # 'dynamic import'
  'colons'
)

$tests = $testList -Join '|'

& cmd.exe /C .\meteor.bat self-test --junit "$jUnit" "$tests" --exclude "$env:SELF_TEST_EXCLUDE" '2>&1'

$selfTestExitCode = $LASTEXITCODE

Write-Host "Self Test Exit $selfTestExitCode"

If ($selfTestExitCode -ne 0) {
  Exit $selfTestExitCode
}
