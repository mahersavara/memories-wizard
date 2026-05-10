using System.Configuration;
using System.Data;
using System.Windows;
using System.IO;
using System;

namespace MemoriesWizard;

/// <summary>
/// Interaction logic for App.xaml
/// </summary>
public partial class App : Application
{
    protected override void OnStartup(StartupEventArgs e)
    {
        base.OnStartup(e);
        this.DispatcherUnhandledException += App_DispatcherUnhandledException;
    }

    private void App_DispatcherUnhandledException(object sender, System.Windows.Threading.DispatcherUnhandledExceptionEventArgs e)
    {
        string logPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "crash.log");
        File.WriteAllText(logPath, $"Error: {e.Exception.Message}\nStack: {e.Exception.StackTrace}");
        MessageBox.Show($"A critical error occurred. Log saved to: {logPath}\n\nError: {e.Exception.Message}", "Critical Error", MessageBoxButton.OK, MessageBoxImage.Error);
        e.Handled = true;
    }
}

