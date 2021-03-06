{Hint: save all files to location: C:\adt32\eclipse\workspace\AppLocationDemo1\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
  Laz_And_Controls_Events, AndroidWidget, location;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jButton1: jButton;
      jButton2: jButton;
      jButton3: jButton;
      jButton4: jButton;
      jCheckBox1: jCheckBox;
      jLocation1: jLocation;
      jTextView1: jTextView;
      jWebView1: jWebView;
      procedure DataModuleCreate(Sender: TObject);
      procedure DataModuleJNIPrompt(Sender: TObject);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jButton3Click(Sender: TObject);
      procedure jButton4Click(Sender: TObject);
      procedure jCheckBox1Click(Sender: TObject);
      procedure jLocation1LocationChanged(Sender: TObject; latitude: double;
        longitude: double; altitude: double; address: string);
      procedure jLocation1LocationProviderDisabled(Sender: TObject;
        provider: string);
      procedure jLocation1LocationProviderEnabled(Sender: TObject;
        provider: string);
      procedure jLocation1LocationStatusChanged(Sender: TObject;
        status: integer; provider: string; msgStatus: string);
    private
      {private declarations}
        FLatitudeVisited: double;
        FLongitudeVisited: double;
        FAltitudeVisited: double;
        FAddress: string;
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.DataModuleCreate(Sender: TObject);
begin
  //
end;

procedure TAndroidModule1.DataModuleJNIPrompt(Sender: TObject);
begin
  if jLocation1.IsWifiEnabled() then  jCheckBox1.Checked:= True;
end;

procedure TAndroidModule1.jCheckBox1Click(Sender: TObject);
begin
   if jCheckBox1.Checked then
   begin
      if not jLocation1.IsWifiEnabled() then
       jLocation1.SetWifiEnabled(True)
     else
       ShowMessage('Wifi is Enabled!');
   end
   else
   begin
      jLocation1.SetWifiEnabled(False);
      ShowMessage('Wifi was Disabled!');
   end;

end;

procedure TAndroidModule1.jLocation1LocationChanged(Sender: TObject;
  latitude: double; longitude: double; altitude: double; address: string);
begin
  FLatitudeVisited:= latitude;
  FLongitudeVisited:= longitude;
  FAltitudeVisited:= altitude;
  FAddress:= address;

  ShowMessage('latitude= ' + IntToStr(Trunc(FLongitudeVisited))       +
              '  :::  longitude= '+IntToStr(Trunc(FLongitudeVisited))+
              '  :::  altitude= '+IntToStr(Trunc(FAltitudeVisited)) +
              '  :::  address= '+FAddress);

end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
  if not jLocation1.IsGPSProvider then
     jLocation1.ShowLocationSouceSettings()
  else
     ShowMessage('GPS is On!');
end;

procedure TAndroidModule1.jButton2Click(Sender: TObject);
begin
   if not jLocation1.StartTracker() then
   begin
      ShowMessage('Please, Wait... No Location Yet!!')
   end
   else
   begin
      FLatitudeVisited:= jLocation1.GetLatitude();
      FLongitudeVisited:= jLocation1.GetLongitude();;
      FAltitudeVisited:= jLocation1.GetAltitude();
      FAddress:=  jLocation1.GetAddress();

      ShowMessage('last lat= ' + IntToStr(Trunc(FLongitudeVisited))       +
                  ' * last long= '+IntToStr(Trunc(FLongitudeVisited))+
                  ' * last alt= '+IntToStr(Trunc(FAltitudeVisited)) +
                  ' * last address= '+FAddress);

   end;
end;

procedure TAndroidModule1.jButton3Click(Sender: TObject);
begin
   jLocation1.StopTracker();
   jLocation1.ShowLocationSouceSettings()
end;

procedure TAndroidModule1.jButton4Click(Sender: TObject);
var
  urlLocation: string;
begin
    //jLocation1.MapType:= mtSatellite;
    urlLocation:= jLocation1.GetGoogleMapsUrl(FLatitudeVisited, FLongitudeVisited);
    ShowMessage(urlLocation);
    jWebView1.Navigate(urlLocation);
end;

procedure TAndroidModule1.jLocation1LocationProviderDisabled(Sender: TObject;
  provider: string);
begin
   ShowMessage('provider= '+provider +' : Disabled!');
end;

procedure TAndroidModule1.jLocation1LocationProviderEnabled(Sender: TObject;
  provider: string);
begin
  ShowMessage('New provider= '+provider +' : Enabled!');
end;

procedure TAndroidModule1.jLocation1LocationStatusChanged(Sender: TObject;
  status: integer; provider: string; msgStatus: string);
begin
  ShowMessage('provider= '+provider+' ::: msgStatus= '+ msgStatus);
end;

end.
