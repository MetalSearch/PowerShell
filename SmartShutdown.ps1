<#
=========================================================================================
.SYNOPSIS
    Arrêt de l'ordinateur avec décompte

.DESCRIPTION
    Ce script PowerShell permet d'arrêter l'ordinateur avec un décompte de secondes
    Tant que le décompte est actif, un utilisateur peut cliquer sur "annuler" afin
    l'extinction de l'ordinateur. Dans le cas contraire, au bout du décompte ou si
    aucune session n'est ouverte l'ordinateur s'éteindra.

.PARAMETER
    Aucun paramètre n'est requis pour l'exécution de ce script.

.TODO
    Verifier le comportement du script sur des sessions vérouillées

.LINK
        https://github.com/MetalSearch/PowerShell/tree/main
=========================================================================================
#>

# Charger l'assembly System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms

# Fonction pour vérifier si une session d'utilisateur est ouverte
function Get-UserSession {
  $sessions = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName
  return $sessions
}

# Fonction pour éteindre l'ordinateur normalement
function Stop-ComputerNormally {
  Write-Host "Aucune session ouverte. L'ordinateur va s'éteindre."
  Stop-Computer -Force
}

# Fonction pour informer l'utilisateur et éteindre l'ordinateur avec un décompte
function Stop-ComputerWithCountdown {
  # Déclarer les variables de script
  $script:countdown = 30
  $script:cancelled = $false

  # Créer un formulaire pour afficher le décompte
  $form = New-Object System.Windows.Forms.Form
  $form.Text = "Arrêt de l'ordinateur"
  $form.Size = New-Object System.Drawing.Size(300, 150)
  $form.StartPosition = "CenterScreen"

  # Créer un label pour afficher le décompte
  $script:label = New-Object System.Windows.Forms.Label
  $script:label.AutoSize = $true
  $script:label.Location = New-Object System.Drawing.Point(50, 20)
  $script:label.Text = "L'ordinateur va être arrêté dans $script:countdown secondes."
  $form.Controls.Add($script:label)

  # Créer un bouton pour annuler l'arrêt
  $button = New-Object System.Windows.Forms.Button
  $button.Location = New-Object System.Drawing.Point(100, 70)
  $button.Size = New-Object System.Drawing.Size(75, 23)
  $button.Text = "Annuler"
  $button.Add_Click({
    $script:cancelled = $true
    $form.Close()
  })
  $form.Controls.Add($button)

  # Créer un timer pour le décompte
  $timer = New-Object System.Windows.Forms.Timer
  $timer.Interval = 1000 # 1 seconde
  $timer.Add_Tick({
    if ($script:countdown -gt 0 -and -not $script:cancelled) {
      $script:countdown--
      $script:label.Text = "L'ordinateur va être arrêté dans $script:countdown secondes."
    } elseif ($script:countdown -eq 0) {
      $timer.Stop()
      $form.Close() # Fermer le formulaire avant d'éteindre
      Stop-Computer -Force
    }
  })

  # Démarrer le timer et afficher le formulaire
  $timer.Start()
  $form.ShowDialog()

  # Si le bouton Annuler a été cliqué, arrêter le timer
  if ($script:cancelled) {
    $timer.Stop()
    Write-Host "L'arrêt de l'ordinateur a été annulé."
  }
}

# Vérifier si une session d'utilisateur est ouverte
$sessions = Get-UserSession

if (-not $sessions) {
  # Aucune session ouverte, éteindre l'ordinateur normalement
  Stop-ComputerNormally
} else {
  # Une session est ouverte, informer l'utilisateur et éteindre l'ordinateur avec un décompte
  Stop-ComputerWithCountdown
}
