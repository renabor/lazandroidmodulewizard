{Hint: save all files to location: C:\adt32\eclipse\workspace\AppCameraDemo\jni }
unit unit1;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls, 
    Laz_And_Controls_Events, AndroidWidget;
  
type

  { TAndroidModule1 }

  TAndroidModule1 = class(jForm)
      jBitmap1: jBitmap;
      jButton1: jButton;
      jCamera1: jCamera;
      jCanvas1: jCanvas;
      jEditText1: jEditText;
      jImageView1: jImageView;
      jPanel1: jPanel;
      jPanel2: jPanel;
      jPanel3: jPanel;
      jPanel4: jPanel;
      jPanel5: jPanel;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jView1: jView;
      procedure AndroidModule1ActivityRst(Sender: TObject; requestCode, resultCode: Integer; jData: jObject);
      procedure AndroidModule1Create(Sender: TObject);
      procedure AndroidModule1JNIPrompt(Sender: TObject);
      procedure AndroidModule1Rotate(Sender: TObject; rotate: integer; var rstRotate: integer);
      procedure jButton1Click(Sender: TObject);
      procedure jView1Draw(Sender: TObject; Canvas: jCanvas);
    private
      {private declarations}
      FPhotoExist: boolean;
      FSaveRotate: integer;
    public
      {public declarations}
  end;
  
var
  AndroidModule1: TAndroidModule1;

implementation
  
{$R *.lfm}

{ TAndroidModule1 }

procedure TAndroidModule1.AndroidModule1Rotate(Sender: TObject; rotate: integer; var rstRotate: integer);
begin
   FSaveRotate:=  rotate;
   if rotate = 2 then
   begin         //after rotation device is on horizontal
          jPanel1.LayoutParamHeight:= lpMatchParent;
          jPanel1.LayoutParamWidth:= lpOneQuarterOfParent;

          jPanel1.PosRelativeToParent:= [rpLeft];

          jPanel2.LayoutParamHeight:= lpMatchParent;
          jPanel2.LayoutParamWidth:= lpOneThirdOfParent;
          jPanel2.PosRelativeToAnchor:= [raToRightOf,raAlignBaseline];

          jPanel3.PosRelativeToAnchor:= [raToRightOf,raAlignBaseline];;

          jPanel1.ResetAllRules;
          jPanel2.ResetAllRules;
          jPanel3.ResetAllRules;

          //jPanel5.PosRelativeToParent:= [rpCenterInParent];
          //jPanel5.ResetAllRules;

          Self.UpdateLayout;
   end
   else
   begin      //after rotation device is on vertical :: default
          jPanel1.LayoutParamHeight:= lpOneQuarterOfParent;
          jPanel1.LayoutParamWidth:= lpMatchParent;
          jPanel1.PosRelativeToParent:= [rpTop];

          jPanel2.LayoutParamHeight:= lpOneThirdOfParent;
          jPanel2.LayoutParamWidth:= lpMatchParent;
          jPanel2.PosRelativeToAnchor:= [raBelow];

          jPanel3.PosRelativeToAnchor:= [raBelow];

          jPanel1.ResetAllRules;
          jPanel2.ResetAllRules;
          jPanel3.ResetAllRules;

          //jPanel5.PosRelativeToParent:= [rpBottom];
          //jPanel5.ResetAllRules;

          Self.UpdateLayout;
      end;
end;

procedure TAndroidModule1.jButton1Click(Sender: TObject);
begin
   jCamera1.RequestCode:= 12345;
   jCamera1.TakePhoto;
   //ShowMessage('clicked ...');
end;

procedure TAndroidModule1.jView1Draw(Sender: TObject; Canvas: jCanvas);
var
  ratio: single;
  size, w, h: integer;
begin
    if FPhotoExist then
    begin

       w:= jBitmap1.Width;       //ex. Width: 640   ... Height: 480
       h:= jBitmap1.Height;

       //Ratio > 1 !
       if w > h then Ratio:= w/h
       else  Ratio:= h/w;

       if FSaveRotate = 2 then
       begin
          Ratio:= Round(jBitmap1.Width/jBitmap1.Height);
          jView1.Canvas.drawBitmap(jBitmap1, 0, 0,
                                             jView1.Width,
                                             Ratio);
       end
       else
       begin
         Ratio:= Round(jBitmap1.Height/jBitmap1.Width);
         jView1.Canvas.drawBitmap(jBitmap1, 0, 0,
                                            jView1.Height,
                                            Ratio);
       end;
        //or you can do simply this...  NO RATIO!
       //jView1.Canvas.drawBitmap(jBitmap1, 0, 0, jView1.Width, jView1.Height);

       //just to ilustration.... you can draw and write over....
       jView1.Canvas.PaintColor:= colbrRed;
       jView1.Canvas.drawLine(0, 0, jView1.Width, jView1.Height);
       jView1.Canvas.drawText('Hello People!', 30,30);

       //or simply show on other control: jImageView1  .... just WrapContent!
        jImageView1.SetImageBitmap(jBitmap1.GetJavaBitmap);
    end;
end;

procedure TAndroidModule1.AndroidModule1Create(Sender: TObject);
begin
   FPhotoExist:= False;
   FSaveRotate:= 1;  //default: Vertical
end;

procedure TAndroidModule1.AndroidModule1JNIPrompt(Sender: TObject);
begin
  if Self.Orientation = 2 then   // device is on horizontal...
  begin               //reconfigure....

     FSaveRotate:= 2;

     jPanel1.LayoutParamHeight:= lpMatchParent;

     jPanel1.LayoutParamWidth:= lpOneThirdOfParent;
     jPanel1.PosRelativeToParent:= [rpLeft];

     jPanel2.LayoutParamHeight:= lpMatchParent;
     jPanel2.LayoutParamWidth:= lpOneThirdOfParent;
     jPanel2.PosRelativeToAnchor:= [raToRightOf,raAlignBaseline];

     jPanel3.PosRelativeToAnchor:= [raToRightOf,raAlignBaseline];;

     jPanel1.ResetAllRules;
     jPanel2.ResetAllRules;
     jPanel3.ResetAllRules;

     jPanel5.PosRelativeToParent:= [rpCenterInParent];
     jPanel5.ResetAllRules;

     Self.UpdateLayout;
  end;
  jEditText1.SetFocus;
end;

procedure TAndroidModule1.AndroidModule1ActivityRst(Sender: TObject; requestCode, resultCode: Integer; jData: jObject);
begin
   if resultCode = 0 then ShowMessage('Photo Canceled!')
   else if resultCode = -1 then //ok...
        begin
           if  requestCode = jCamera1.RequestCode then
           begin
             ShowMessage('Ok!');
             jBitmap1.LoadFromFile(jCamera1.FullPathToBitmapFile);
             FPhotoExist:= True;
             jView1.Refresh;
             jImageView1.Refresh;
           end;
   end
   else ShowMessage('Photo Fail!');
end;

end.
