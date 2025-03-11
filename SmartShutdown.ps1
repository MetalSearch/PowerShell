<#
 Arrêt de l'ordinateur avec décompte
#>

# Charger l'assembly System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms
# Vérifier si une session d'utilisateur est ouverte
$sessions = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName

if (-not $sessions) {
    # Aucune session ouverte, éteindre l'ordinateur normalement
    Write-Host "Aucune session ouverte. L'ordinateur va s'éteindre."
    Stop-Computer -Force
} else {
    # Une session est ouverte, informer l'utilisateur
    $title = "Arrêt de l'ordinateur"
    $script:countdown = 30 # Déclarer la variable comme variable de script
    $script:cancelled = $false # Déclarer la variable comme variable de script

    # Créer un formulaire pour afficher le décompte
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $title
    $form.Size = New-Object System.Drawing.Size(300, 150)
    $form.StartPosition = "CenterScreen"

    $label = New-Object System.Windows.Forms.Label
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(50, 20)
    $label.Text = "L'ordinateur va être arrêté dans $script:countdown secondes."
    $form.Controls.Add($label)

    $button = New-Object System.Windows.Forms.Button
    $button.Location = New-Object System.Drawing.Point(100, 70)
    $button.Size = New-Object System.Drawing.Size(75, 23)
    $button.Text = "Annuler"
    $button.Add_Click({
        $script:cancelled = $true # Mettre à jour la variable de script
        $form.Close()
    })
    $form.Controls.Add($button)

    # Créer un timer pour le décompte
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 1000 # 1 seconde
    $timer.Add_Tick({
        if ($script:countdown -gt 0 -and -not $script:cancelled) {
            $script:countdown--
            $label.Text = "L'ordinateur va être arrêté dans $script:countdown secondes."
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
