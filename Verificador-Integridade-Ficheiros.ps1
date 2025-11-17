<#
.SYNOPSIS
    Verificador de Integridade de Ficheiros
.DESCRIPTION
    Ferramenta para calcular e verificar hashes SHA-256, SHA-1 e MD5
.AUTHOR
    OzzyCavalera
.VERSION
    1.0.0
#>

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

$global:SelectedFile = $null
$global:CurrentHash = @{SHA256=""; SHA1=""; MD5=""}

[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="🔐 Verificador de Integridade de Ficheiros" 
    Height="700" 
    Width="750"
    WindowStartupLocation="CenterScreen"
    ResizeMode="CanMinimize"
    Background="#FF1E1E2E">
    
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Padding" Value="15,10"/>
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="8" BorderThickness="0">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    
    <Grid Margin="20">
        <Grid.Background>
            <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                <GradientStop Color="#FF1E1E2E" Offset="0"/>
                <GradientStop Color="#FF2E3440" Offset="1"/>
            </LinearGradientBrush>
        </Grid.Background>
        
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        
        <TextBlock Grid.Row="0" Text="🔐 Verificador de Integridade" FontSize="28" FontWeight="Bold" Foreground="#FF88C0D0" HorizontalAlignment="Center" Margin="0,0,0,20"/>
        
        <Border Grid.Row="1" Background="#FF2E3440" CornerRadius="10" Padding="15" Margin="0,0,0,15">
            <StackPanel>
                <TextBlock Text="📁 Ficheiro Selecionado:" Foreground="#FF88C0D0" FontSize="14" FontWeight="Bold" Margin="0,0,0,10"/>
                <TextBox Name="txtFilePath" IsReadOnly="True" Background="#FF3B4252" Foreground="White" BorderBrush="#FF4C566A" Padding="10" FontSize="12" Text="Nenhum ficheiro selecionado" TextWrapping="Wrap"/>
                <Button Name="btnSelectFile" Content="📂 Selecionar Ficheiro" Margin="0,10,0,0">
                    <Button.Background>
                        <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                            <GradientStop Color="#FF5E81AC" Offset="0"/>
                            <GradientStop Color="#FF81A1C1" Offset="1"/>
                        </LinearGradientBrush>
                    </Button.Background>
                </Button>
            </StackPanel>
        </Border>
        
        <Border Grid.Row="2" Background="#FF2E3440" CornerRadius="10" Padding="15" Margin="0,0,0,15">
            <StackPanel>
                <TextBlock Text="🔒 Selecionar Algoritmo:" Foreground="#FF88C0D0" FontSize="14" FontWeight="Bold" Margin="0,0,0,10"/>
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                    <RadioButton Name="rbSHA256" Content="SHA-256" Foreground="White" IsChecked="True" Margin="10,0" FontSize="13"/>
                    <RadioButton Name="rbSHA1" Content="SHA-1" Foreground="White" Margin="10,0" FontSize="13"/>
                    <RadioButton Name="rbMD5" Content="MD5" Foreground="White" Margin="10,0" FontSize="13"/>
                </StackPanel>
            </StackPanel>
        </Border>
        
        <Border Grid.Row="3" Background="#FF2E3440" CornerRadius="10" Padding="15">
            <ScrollViewer VerticalScrollBarVisibility="Auto">
                <StackPanel>
                    <TextBlock Text="📊 Hashes Calculados:" Foreground="#FF88C0D0" FontSize="14" FontWeight="Bold" Margin="0,0,0,10"/>
                    
                    <StackPanel Margin="0,5">
                        <TextBlock Text="SHA-256:" Foreground="#FFA3BE8C" FontWeight="Bold" FontSize="12"/>
                        <TextBox Name="txtSHA256" IsReadOnly="True" Background="#FF3B4252" Foreground="#FFECEFF4" BorderThickness="0" Padding="5" FontFamily="Consolas" FontSize="11" TextWrapping="Wrap"/>
                    </StackPanel>
                    
                    <StackPanel Margin="0,10,0,5">
                        <TextBlock Text="SHA-1:" Foreground="#FFEBCB8B" FontWeight="Bold" FontSize="12"/>
                        <TextBox Name="txtSHA1" IsReadOnly="True" Background="#FF3B4252" Foreground="#FFECEFF4" BorderThickness="0" Padding="5" FontFamily="Consolas" FontSize="11" TextWrapping="Wrap"/>
                    </StackPanel>
                    
                    <StackPanel Margin="0,10,0,5">
                        <TextBlock Text="MD5:" Foreground="#FFD08770" FontWeight="Bold" FontSize="12"/>
                        <TextBox Name="txtMD5" IsReadOnly="True" Background="#FF3B4252" Foreground="#FFECEFF4" BorderThickness="0" Padding="5" FontFamily="Consolas" FontSize="11" TextWrapping="Wrap"/>
                    </StackPanel>
                    
                    <Border Background="#FF3B4252" CornerRadius="5" Padding="10" Margin="0,15,0,0">
                        <StackPanel>
                            <TextBlock Text="✅ Verificar Hash:" Foreground="#FF88C0D0" FontWeight="Bold" FontSize="12" Margin="0,0,0,5"/>
                            <TextBox Name="txtExpectedHash" Background="#FF434C5E" Foreground="White" BorderBrush="#FF4C566A" Padding="8" FontFamily="Consolas" FontSize="11" TextWrapping="Wrap"/>
                            <Button Name="btnVerify" Content="🔍 Comparar Hash" Margin="0,10,0,0">
                                <Button.Background>
                                    <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                                        <GradientStop Color="#FFA3BE8C" Offset="0"/>
                                        <GradientStop Color="#FF8FBCBB" Offset="1"/>
                                    </LinearGradientBrush>
                                </Button.Background>
                            </Button>
                            <TextBlock Name="txtVerificationResult" Text="" Foreground="White" FontWeight="Bold" FontSize="13" HorizontalAlignment="Center" Margin="0,10,0,0"/>
                        </StackPanel>
                    </Border>
                </StackPanel>
            </ScrollViewer>
        </Border>
        
        <Grid Grid.Row="4" Margin="0,15,0,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            
            <Button Name="btnCalculate" Grid.Column="0" Content="⚡ Calcular Hashes">
                <Button.Background>
                    <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                        <GradientStop Color="#FF5E81AC" Offset="0"/>
                        <GradientStop Color="#FF88C0D0" Offset="1"/>
                    </LinearGradientBrush>
                </Button.Background>
            </Button>
            
            <Button Name="btnCopy" Grid.Column="1" Content="📋 Copiar Hash">
                <Button.Background>
                    <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                        <GradientStop Color="#FFBF616A" Offset="0"/>
                        <GradientStop Color="#FFD08770" Offset="1"/>
                    </LinearGradientBrush>
                </Button.Background>
            </Button>
        </Grid>
        
        <StackPanel Grid.Row="5" Margin="0,15,0,0">
            <TextBlock Name="txtStatus" Text="Pronto" Foreground="#FF88C0D0" FontSize="12" HorizontalAlignment="Center" Margin="0,0,0,5"/>
            <ProgressBar Name="progressBar" Height="8" Background="#FF3B4252" Foreground="#FF88C0D0" Minimum="0" Maximum="100" Value="0"/>
        </StackPanel>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$txtFilePath = $window.FindName("txtFilePath")
$txtSHA256 = $window.FindName("txtSHA256")
$txtSHA1 = $window.FindName("txtSHA1")
$txtMD5 = $window.FindName("txtMD5")
$txtExpectedHash = $window.FindName("txtExpectedHash")
$txtVerificationResult = $window.FindName("txtVerificationResult")
$txtStatus = $window.FindName("txtStatus")
$btnSelectFile = $window.FindName("btnSelectFile")
$btnCalculate = $window.FindName("btnCalculate")
$btnCopy = $window.FindName("btnCopy")
$btnVerify = $window.FindName("btnVerify")
$rbSHA256 = $window.FindName("rbSHA256")
$rbSHA1 = $window.FindName("rbSHA1")
$rbMD5 = $window.FindName("rbMD5")
$progressBar = $window.FindName("progressBar")

$btnSelectFile.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Title = "Selecionar Ficheiro"
    $openFileDialog.Filter = "Todos os ficheiros (*.*)|*.*"
    
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $global:SelectedFile = $openFileDialog.FileName
        $txtFilePath.Text = $global:SelectedFile
        $txtStatus.Text = "Ficheiro selecionado: $(Split-Path $global:SelectedFile -Leaf)"
    }
})

$btnCalculate.Add_Click({
    if (-not $global:SelectedFile -or -not (Test-Path $global:SelectedFile)) {
        [System.Windows.MessageBox]::Show("Por favor, selecione um ficheiro válido!", "Aviso", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }
    
    $txtStatus.Text = "A calcular hashes..."
    $progressBar.Value = 0
    
    $window.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::ContextIdle)
    
    try {
        $progressBar.Value = 33
        $global:CurrentHash.SHA256 = (Get-FileHash -Path $global:SelectedFile -Algorithm SHA256).Hash
        $txtSHA256.Text = $global:CurrentHash.SHA256
        
        $progressBar.Value = 66
        $global:CurrentHash.SHA1 = (Get-FileHash -Path $global:SelectedFile -Algorithm SHA1).Hash
        $txtSHA1.Text = $global:CurrentHash.SHA1
        
        $progressBar.Value = 100
        $global:CurrentHash.MD5 = (Get-FileHash -Path $global:SelectedFile -Algorithm MD5).Hash
        $txtMD5.Text = $global:CurrentHash.MD5
        
        $txtStatus.Text = "✅ Hashes calculados com sucesso!"
        $txtVerificationResult.Text = ""
    }
    catch {
        [System.Windows.MessageBox]::Show("Erro ao calcular hashes: $($_.Exception.Message)", "Erro", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
        $txtStatus.Text = "❌ Erro ao calcular hashes"
        $progressBar.Value = 0
    }
})
$btnCopy.Add_Click({
    $selectedHash = ""
    
    if ($rbSHA256.IsChecked) {
        $selectedHash = $global:CurrentHash.SHA256
    }
    elseif ($rbSHA1.IsChecked) {
        $selectedHash = $global:CurrentHash.SHA1
    }
    elseif ($rbMD5.IsChecked) {
        $selectedHash = $global:CurrentHash.MD5
    }
    
    if ($selectedHash) {
        [System.Windows.Clipboard]::SetText($selectedHash)
        $txtStatus.Text = "📋 Hash copiado para a área de transferência!"
    }
    else {
        [System.Windows.MessageBox]::Show("Por favor, calcule os hashes primeiro!", "Aviso", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

$btnVerify.Add_Click({
    $expectedHash = $txtExpectedHash.Text.
Trim().ToUpper()
    
    if ([string]::IsNullOrWhiteSpace($expectedHash)) {
        [System.Windows.MessageBox]::Show("Por favor, insira o hash esperado!", "Aviso", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }
    
    $currentHash = ""
    $algorithm = ""
    
    if ($rbSHA256.IsChecked) {
        $currentHash = $global:CurrentHash.SHA256
        $algorithm = "SHA-256"
    }
    elseif ($rbSHA1.IsChecked) {
        $currentHash = $global:CurrentHash.SHA1
        $algorithm = "SHA-1"
    }
    elseif ($rbMD5.IsChecked) {
        $currentHash = $global:CurrentHash.MD5
        $algorithm = "MD5"
    }
    
    if ([string]::IsNullOrWhiteSpace($currentHash)) {
        [System.Windows.MessageBox]::Show("Por favor, calcule os hashes primeiro!", "Aviso", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
        return
    }
    
    if ($currentHash -eq $expectedHash) {
        $txtVerificationResult.Text = "✅ HASH VÁLIDO! ($algorithm)"
        $txtVerificationResult.Foreground = "#FFA3BE8C"
        $txtStatus.Text = "✅ Verificação bem-sucedida!"
        [System.Windows.MessageBox]::Show("Hash válido! O ficheiro é íntegro e corresponde ao hash esperado.", "Verificação Bem-Sucedida", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    }
    else {
        $txtVerificationResult.Text = "❌ HASH INVÁLIDO! ($algorithm)"
        $txtVerificationResult.Foreground = "#FFBF616A"
        $txtStatus.Text = "❌ Verificação falhou!"
        [System.Windows.MessageBox]::Show("Hash inválido! O ficheiro pode estar corrompido ou não corresponde ao hash esperado.", "Verificação Falhada", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

$window.ShowDialog() | Out-Null
