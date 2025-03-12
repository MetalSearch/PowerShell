<#
===========================================================================================================================================================
.SYNOPSIS
    Arrêt d'un ordinateur avec prise en compte de la vonlonté de son utilisateur

.DESCRIPTION
    Ce script PowerShell permet d'arrêter un ordinateur tout en laissant la possibilité à un utilisateur d'annuler l'extinction durant un décompte de temps 
    Si aucune session est ouverte, l'ordinateur s'arrête immédiatement.
    Si une session est vérouillée, l'arrêt est abandonné et le script se termine

.PARAMETER
    Aucun paramètre n'est requis pour l'exécution de ce script.

.LINK
        https://github.com/MetalSearch/PowerShell
===========================================================================================================================================================
#>

function Get-SessionUtilisateur {
    [CmdletBinding()]
    param()

    $sessions = (Get-WmiObject -Class Win32_ComputerSystem).UserName
    return $sessions
}

function Test-SessionsVerrouillees {
    [CmdletBinding()]
    param()

    try {
        $sessionState = Get-WmiObject -Class Win32_LogonSession | Where-Object { $_.LogonType -eq 2 }
        if ($sessionState) {
            return (Get-WmiObject -Class Win32_ComputerSystem).UserName -eq $null
        } else {
            return $false
        }
    } catch {
        Write-Error "Échec de la récupération des sessions : $_"
        return $false
    }
}

function Stop-ComputerNormally {
    [CmdletBinding()]
    param()

    Write-Host "Aucune session ouverte. L'ordinateur va s'éteindre."
    Stop-Computer -Force
}

function Show-ShutdownCountdownDialog {
    [CmdletBinding()]
    param(
        $countdownSeconds = 30
    )

    Add-Type -AssemblyName System.Windows.Forms

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Arrêt de l'ordinateur"
    $form.Size = New-Object System.Drawing.Size(300, 150)
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

    $label = New-Object System.Windows.Forms.Label
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(50, 20)
    $label.Text = "L'ordinateur va être arrêté dans $countdownSeconds secondes."
    $form.Controls.Add($label)

    $buttonCancel = New-Object System.Windows.Forms.Button
    $buttonCancel.Location = New-Object System.Drawing.Point(100, 70)
    $buttonCancel.Size = New-Object System.Drawing.Size(75, 23)
    $buttonCancel.Text = "Annuler"
    $buttonCancel.Add_Click({
        $script:cancelled = $true
        $form.Close()
    })
    $form.Controls.Add($buttonCancel)

    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = [System.TimeSpan]::FromSeconds(1)
    $timer.Start()

    $label.DataBindings.Add("Text", ([ref]$countdown), "CountToValue")

    $script:cancelled = $false

    $form.ShowDialog() | Out-Null
}

function Main {
    try {
        # Vérifier si des sessions utilisateur sont ouvertes
        $sessions = Get-SessionUtilisateur
        
        if (-not $sessions) {
            Stop-ComputerNormally
            return
        }

        # Vérifier si les sessions sont verrouillées
        $isLocked = Test-SessionsVerrouillees

        if ($isLocked) {
            Write-Host "La session est verrouillée. L'arrêt ne peut pas être effectué."
            Start-Sleep -Seconds 5
            return
        }

        # Afficher le décompte et attendre l'utilisateur
        Show-ShutdownCountdownDialog

        if ($script:cancelled) {
            Write-Host "L'arrêt a été annulé par l'utilisateur."
            return
        }
    } catch {
        Write-Error $_.Exception.Message
    }

    # Si le décompte est terminé ou si l'utilisateur n'a pas annulé, arrêter l'ordinateur
    Stop-Computer -Force
}

# Lancer l'exécution principale
Main
