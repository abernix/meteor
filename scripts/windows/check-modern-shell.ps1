# Script to detect if the new "Console Improvements" are in effect.
# This will exit with an error if that is not detected when using GetConsoleMode

$MethodDefinitions = @'
[DllImport("kernel32.dll", SetLastError = true)]
public static extern IntPtr GetStdHandle(int nStdHandle);
[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool GetConsoleMode(IntPtr hConsoleHandle,
  out uint lpMode);
'@

$Kernel32 = Add-Type `
  -MemberDefinition $MethodDefinitions `
  -Name 'Kernel32' `
  -Namespace 'Win32' `
  -PassThru

# GetStdHandle
# https://msdn.microsoft.com/en-us/library/windows/desktop/ms683231.aspx
$hConsoleHandle = $Kernel32::GetStdHandle(-11)

# GetConsoleMode
# https://msdn.microsoft.com/en-us/library/windows/desktop/ms683167.aspx
$mode = 0
[void]$Kernel32::GetConsoleMode($hConsoleHandle, [ref]$mode)

# 0x4 = ENABLE_VIRTUAL_TERMINAL_PROCESSING
If ($mode -bAND 0x4) {
  exit 0
}

exit 1
