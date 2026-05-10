using System.IO;
using System.Windows;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using Microsoft.Win32;
using System.Diagnostics;
using System.Linq;
using System.Collections.Generic;
using System.Windows.Media.Animation;

namespace MemoriesWizard;

public partial class MainWindow : Window
{
    private string _sourcePath = string.Empty;
    private string _destPath = string.Empty;
    private List<string> _mediaFiles = new();
    private int _currentIndex = -1;
    private readonly IMediaService _mediaService = new MediaService();

    // Swipe tracking
    private Point _startPoint;
    private bool _isDragging = false;
    private const double SwipeThreshold = 150;

    private bool _isSeeking = false;
    private System.Windows.Threading.DispatcherTimer _timer;

    public MainWindow()
    {
        InitializeComponent();
        this.KeyDown += MainWindow_KeyDown;
        VidPreview.MediaEnded += (s, e) => VidPreview.Position = TimeSpan.Zero;
        VidPreview.MediaFailed += VidPreview_MediaFailed;
        VidPreview.MediaOpened += VidPreview_MediaOpened;

        _timer = new System.Windows.Threading.DispatcherTimer();
        _timer.Interval = TimeSpan.FromMilliseconds(200);
        _timer.Tick += Timer_Tick;
    }

    private void VidPreview_MediaOpened(object sender, RoutedEventArgs e)
    {
        if (VidPreview.NaturalDuration.HasTimeSpan)
        {
            SldSeek.Maximum = VidPreview.NaturalDuration.TimeSpan.TotalSeconds;
            _timer.Start();
            ApplyCurrentSpeed();
        }
    }

    private void ApplyCurrentSpeed()
    {
        if (VidPreview == null || CmbSpeed == null || CmbSpeed.SelectedItem == null) return;
        string val = ((System.Windows.Controls.ComboBoxItem)CmbSpeed.SelectedItem).Content.ToString()!.Replace("x", "");
        if (double.TryParse(val, System.Globalization.CultureInfo.InvariantCulture, out double speed))
        {
            VidPreview.SpeedRatio = speed;
        }
    }

    private void Timer_Tick(object? sender, EventArgs e)
    {
        if (!_isSeeking && VidPreview.NaturalDuration.HasTimeSpan)
        {
            SldSeek.Value = VidPreview.Position.TotalSeconds;
            TxtVidTime.Text = $"{VidPreview.Position:mm\\:ss} / {VidPreview.NaturalDuration.TimeSpan:mm\\:ss}";
        }
    }

    private void SldSeek_DragStarted(object sender, System.Windows.Controls.Primitives.DragStartedEventArgs e) => _isSeeking = true;
    private void SldSeek_DragCompleted(object sender, System.Windows.Controls.Primitives.DragCompletedEventArgs e)
    {
        _isSeeking = false;
        VidPreview.Position = TimeSpan.FromSeconds(SldSeek.Value);
    }
    private void SldSeek_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
    {
        if (_isSeeking) VidPreview.Position = TimeSpan.FromSeconds(SldSeek.Value);
    }

    private void SldVolume_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
    {
        if (VidPreview != null) VidPreview.Volume = SldVolume.Value;
    }

    private void CmbSpeed_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
    {
        ApplyCurrentSpeed();
    }

    private void VidPreview_MediaFailed(object? sender, ExceptionRoutedEventArgs e)
    {
        MessageBox.Show($"Video Playback Error: {e.ErrorException.Message}", "Media Error", MessageBoxButton.OK, MessageBoxImage.Warning);
    }

    private void MainWindow_KeyDown(object sender, KeyEventArgs e)
    {
        if (MediaScreen.Visibility != Visibility.Visible) return;

        switch (e.Key)
        {
            case Key.Right: AnimateOffScreen(Decision.Keep, 1000, 0); break;
            case Key.Left: AnimateOffScreen(Decision.Skip, -1000, 0); break;
            case Key.Down: AnimateOffScreen(Decision.Trash, 0, 1000); break;
        }
    }

    private void TitleBar_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
    {
        if (e.LeftButton == MouseButtonState.Pressed) DragMove();
    }

    private void Minimize_Click(object sender, RoutedEventArgs e) => WindowState = WindowState.Minimized;
    
    private void Maximize_Click(object sender, RoutedEventArgs e)
    {
        if (WindowState == WindowState.Maximized)
        {
            WindowState = WindowState.Normal;
            BtnMaximize.Content = "▢";
        }
        else
        {
            WindowState = WindowState.Maximized;
            BtnMaximize.Content = "❐";
        }
    }

    private void Close_Click(object sender, RoutedEventArgs e) => Close();

    private void BrowseSource_Click(object sender, RoutedEventArgs e)
    {
        var dialog = new OpenFolderDialog { Title = "Select Source Folder" };
        if (dialog.ShowDialog() == true)
        {
            _sourcePath = dialog.FolderName;
            TxtSourcePath.Text = _sourcePath;
            UpdateMediaCount();
        }
    }

    private void UpdateMediaCount()
    {
        var files = _mediaService.GetMediaFiles(_sourcePath, ChkRecursive.IsChecked == true);
        TxtMediaCount.Text = $"{files.Count} media files found.";
    }

    private void ChkRecursive_Changed(object sender, RoutedEventArgs e)
    {
        if (IsLoaded) UpdateMediaCount();
    }

    private void BrowseDest_Click(object sender, RoutedEventArgs e)
    {
        var dialog = new OpenFolderDialog { Title = "Select Destination Folder" };
        if (dialog.ShowDialog() == true) TxtDestPath.Text = _destPath = dialog.FolderName;
    }

    private void Start_Click(object sender, RoutedEventArgs e)
    {
        if (string.IsNullOrEmpty(_sourcePath) || string.IsNullOrEmpty(_destPath))
        {
            MessageBox.Show("Please select both folders.", "Required", MessageBoxButton.OK, MessageBoxImage.Warning);
            return;
        }
        InitializeMediaQueue();
    }

    private void InitializeMediaQueue()
    {
        _mediaFiles = _mediaService.GetMediaFiles(_sourcePath, ChkRecursive.IsChecked == true);

        if (_mediaFiles.Count == 0)
        {
            MessageBox.Show("No media files found.", "Empty", MessageBoxButton.OK, MessageBoxImage.Information);
            return;
        }

        TxtTotalCount.Text = $" / {_mediaFiles.Count}";
        _currentIndex = 0;
        MenuScreen.Visibility = Visibility.Collapsed;
        MediaScreen.Visibility = Visibility.Visible;
        LoadCurrentMedia();
    }

    private void ShowNextMedia()
    {
        _currentIndex++;
        if (_currentIndex >= _mediaFiles.Count)
        {
            ShowSuccess();
            return;
        }
        LoadCurrentMedia();
    }

    private void LoadCurrentMedia()
    {
        if (_currentIndex < 0 || _currentIndex >= _mediaFiles.Count) return;

        // Reset animations
        MediaTransform.BeginAnimation(TranslateTransform.XProperty, null);
        MediaTransform.BeginAnimation(TranslateTransform.YProperty, null);
        MediaRotate.BeginAnimation(RotateTransform.AngleProperty, null);
        MediaTransform.X = 0;
        MediaTransform.Y = 0;
        MediaRotate.Angle = 0;
        TxtIndicator.Opacity = 0;

        string file = _mediaFiles[_currentIndex];
        TxtFileName.Text = Path.GetFileName(file);
        TxtCurrentIndex.Text = (_currentIndex + 1).ToString();
        
        bool isVideo = new[] { ".mp4", ".mov", ".wmv", ".avi" }.Contains(Path.GetExtension(file).ToLower());

        if (isVideo)
        {
            ImgPreview.Visibility = Visibility.Collapsed;
            VidPreview.Visibility = Visibility.Visible;
            VidPreview.Source = new Uri(Path.GetFullPath(file));
            VidPreview.Play();
            VidControls.Visibility = Visibility.Visible;
        }
        else
        {
            _timer.Stop();
            VidControls.Visibility = Visibility.Collapsed;
            VidPreview.Visibility = Visibility.Collapsed;
            VidPreview.Stop();
            VidPreview.Source = null;
            ImgPreview.Visibility = Visibility.Visible;
            
            var bitmap = new BitmapImage();
            bitmap.BeginInit();
            bitmap.UriSource = new Uri(file);
            bitmap.CacheOption = BitmapCacheOption.OnLoad;
            bitmap.EndInit();
            ImgPreview.Source = bitmap;
        }
    }

    private void TxtCurrentIndex_KeyDown(object sender, KeyEventArgs e)
    {
        if (e.Key == Key.Enter)
        {
            if (int.TryParse(TxtCurrentIndex.Text, out int newIndex))
            {
                if (newIndex >= 1 && newIndex <= _mediaFiles.Count)
                {
                    VidPreview.Stop();
                    VidPreview.Source = null;
                    _currentIndex = newIndex - 1;
                    LoadCurrentMedia();
                    MediaContainer.Focus();
                }
                else
                {
                    TxtCurrentIndex.Text = (_currentIndex + 1).ToString();
                }
            }
            else
            {
                TxtCurrentIndex.Text = (_currentIndex + 1).ToString();
            }
        }
    }

    private void CompleteNow_Click(object sender, RoutedEventArgs e)
    {
        VidPreview.Stop();
        VidPreview.Source = null;
        ShowSuccess();
    }

    private void ProcessDecision(Decision decision)
    {
        string currentFile = _mediaFiles[_currentIndex];
        VidPreview.Stop();
        VidPreview.Source = null;
        ImgPreview.Source = null;

        try
        {
            switch (decision)
            {
                case Decision.Keep:
                    _mediaService.MoveToDestination(currentFile, _destPath);
                    break;
                case Decision.Trash:
                    _mediaService.SendToRecycleBin(currentFile);
                    break;
                case Decision.Skip:
                    break;
            }
        }
        catch (Exception ex)
        {
            MessageBox.Show($"Error: {ex.Message}", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
        }

        ShowNextMedia();
    }

    private void ShowSuccess()
    {
        MediaScreen.Visibility = Visibility.Collapsed;
        SuccessScreen.Visibility = Visibility.Visible;
    }

    private void BackToMenu_Click(object sender, RoutedEventArgs e)
    {
        SuccessScreen.Visibility = Visibility.Collapsed;
        MenuScreen.Visibility = Visibility.Visible;
    }

    private void OpenDest_Click(object sender, RoutedEventArgs e)
    {
        Process.Start("explorer.exe", _destPath);
    }

    // Swipe Logic
    private void MediaContainer_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
    {
        _startPoint = e.GetPosition(this);
        _isDragging = true;
        MediaContainer.CaptureMouse();
        
        // Clear any running animations
        MediaTransform.BeginAnimation(TranslateTransform.XProperty, null);
        MediaTransform.BeginAnimation(TranslateTransform.YProperty, null);
        MediaRotate.BeginAnimation(RotateTransform.AngleProperty, null);
    }

    private void MediaContainer_MouseMove(object sender, MouseEventArgs e)
    {
        if (!_isDragging) return;

        Point currentPoint = e.GetPosition(this);
        double deltaX = currentPoint.X - _startPoint.X;
        double deltaY = currentPoint.Y - _startPoint.Y;

        MediaTransform.X = deltaX;
        MediaTransform.Y = deltaY;
        MediaRotate.Angle = deltaX / 15.0; // Tinder-like tilt

        if (Math.Abs(deltaX) > Math.Abs(deltaY))
        {
            if (deltaX > 50) { TxtIndicator.Text = "KEEP"; TxtIndicator.Foreground = Brushes.LightGreen; TxtIndicator.Opacity = Math.Min(1, deltaX / SwipeThreshold); }
            else if (deltaX < -50) { TxtIndicator.Text = "SKIP"; TxtIndicator.Foreground = Brushes.LightGray; TxtIndicator.Opacity = Math.Min(1, -deltaX / SwipeThreshold); }
            else TxtIndicator.Opacity = 0;
        }
        else
        {
            if (deltaY > 50) { TxtIndicator.Text = "TRASH"; TxtIndicator.Foreground = Brushes.Salmon; TxtIndicator.Opacity = Math.Min(1, deltaY / SwipeThreshold); }
            else TxtIndicator.Opacity = 0;
        }
    }

    private void MediaContainer_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
    {
        if (!_isDragging) return;
        _isDragging = false;
        MediaContainer.ReleaseMouseCapture();

        double deltaX = MediaTransform.X;
        double deltaY = MediaTransform.Y;

        if (deltaX > SwipeThreshold) AnimateOffScreen(Decision.Keep, 1000, deltaY);
        else if (deltaX < -SwipeThreshold) AnimateOffScreen(Decision.Skip, -1000, deltaY);
        else if (deltaY > SwipeThreshold) AnimateOffScreen(Decision.Trash, deltaX, 1000);
        else
        {
            // Spring back to center
            var ease = new BackEase { Amplitude = 0.5, EasingMode = EasingMode.EaseOut };
            var animX = new DoubleAnimation(0, TimeSpan.FromMilliseconds(250)) { EasingFunction = ease };
            var animY = new DoubleAnimation(0, TimeSpan.FromMilliseconds(250)) { EasingFunction = ease };
            var animRot = new DoubleAnimation(0, TimeSpan.FromMilliseconds(250)) { EasingFunction = ease };
            var animOpacity = new DoubleAnimation(0, TimeSpan.FromMilliseconds(150));

            MediaTransform.BeginAnimation(TranslateTransform.XProperty, animX);
            MediaTransform.BeginAnimation(TranslateTransform.YProperty, animY);
            MediaRotate.BeginAnimation(RotateTransform.AngleProperty, animRot);
            TxtIndicator.BeginAnimation(OpacityProperty, animOpacity);
        }
    }

    private void AnimateOffScreen(Decision decision, double targetX, double targetY)
    {
        var animX = new DoubleAnimation(targetX, TimeSpan.FromMilliseconds(300)) { EasingFunction = new ExponentialEase { Exponent = 2, EasingMode = EasingMode.EaseIn } };
        var animY = new DoubleAnimation(targetY, TimeSpan.FromMilliseconds(300)) { EasingFunction = new ExponentialEase { Exponent = 2, EasingMode = EasingMode.EaseIn } };
        var animRot = new DoubleAnimation(MediaRotate.Angle * 2, TimeSpan.FromMilliseconds(300));

        animX.Completed += (s, e) => ProcessDecision(decision);

        MediaTransform.BeginAnimation(TranslateTransform.XProperty, animX);
        MediaTransform.BeginAnimation(TranslateTransform.YProperty, animY);
        MediaRotate.BeginAnimation(RotateTransform.AngleProperty, animRot);
    }

    private enum Decision { Keep, Skip, Trash }
}