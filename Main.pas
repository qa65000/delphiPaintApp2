unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts;

type
  { Line��\�����邽�߂̈ʒu�ւ̏�� ssStart = �J�n, ssNext= �p���@, ssEnd =�I�[ }
 TLineStatus = (sStart, sNext, sEnd);

  { Line �`��̈ʒu�AStatus���\���̂Ƃ��Ē�`}
  TLinePoint = record
          Positon : TPointF;
          Status  : TLineStatus;
          Color   : TAlphaColor;      { �F���ǉ�}
   end;
  PLinePoint = ^TLinePoint;
  TMainForm = class(TForm)
    Layout1: TLayout;
    PaintBox1: TPaintBox;
    ColorPalettePanel: TRectangle;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
    Rectangle6: TRectangle;
    Rectangle7: TRectangle;
    Rectangle8: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
    procedure ColorClick(Sender: TObject);
  private
    DrawPoints  : TList<TLinePoint>;
    PressStatus : Boolean;
    SelectColor : TAlphaColor;       { �F���ǉ� }
    procedure AddPoint(const x, y: single; const Status: TLineStatus; Color: TAlphaColor); { �F���ǉ� }
     { private �錾 }

  public
    { public �錾 }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.FormCreate(Sender: TObject);
begin
    DrawPoints  := TList<TLinePoint>.Create;  { �`��p�̓_���X�g�̍\�z }
    SelectColor :=  TAlphaColorRec.Black;     { �����F�����Ƃ��� }
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DrawPoints.DisposeOf;   { �`��p�̓_���X�g�̔j�� }
end;

procedure TMainForm.AddPoint(const x, y: single; const Status: TLineStatus; Color: TAlphaColor);
var
    TLP: TLinePoint;    { ��Line Point }
begin
        if(DrawPoints.Count < 0 ) then exit;   { �}�C�i�X�͂��蓾�Ȃ� }

        TLP.Color   := Color;                  { �F�f�[�^�ݒ� }
        TLP.Positon := PointF(x, y);           { �ݒ�f�[�^���쐬 }
        TLP.Status  := Status;
        DrawPoints.Add(TLP);                   { List�ɒǉ� }
        PaintBox1.Repaint;                     { �ĕ`�� }
end;

procedure TMainForm.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
     if ssLeft in Shift then      { ���{�^�������Ă���H }
     begin
       PressStatus := True;       { ���{�^��������Ԑݒ� }
       AddPoint( x, y ,sStart,SelectColor);   { �`��p�̓_�ݒ�:�J�n}
     end;
end;

procedure TMainForm.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
     if ssLeft in Shift then      { ���{�^�������Ă���H }
     begin
       if(PressStatus =  True) then  { �������o�ς�?}
       AddPoint( x, y ,sNext,SelectColor);   { �`��p�̓_�ݒ�:�p��}
     end;
end;

procedure TMainForm.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    if(PressStatus =  True) then
    begin
       AddPoint( x, y ,sEnd,SelectColor);   { �`��p�̓_�ݒ�:�I�[}
    end;
    PressStatus := false;       {������Ԃ�����}
end;

procedure TMainForm.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
var
   TLP: TLinePoint;    { ��Line Point }
   StartPoint : TPointF;
begin
        if(DrawPoints.Count < 0 ) then exit;   { �}�C�i�X�͂��蓾�Ȃ� }

        Canvas.Stroke.Kind := TBrushKind.Solid;     {�Ƃ肠�����̃y���F����}
        Canvas.Stroke.Dash := TStrokeDash.Solid;
        Canvas.Stroke.Thickness := 2;
   //   Canvas.Stroke.Color := TAlphaColorRec.Black;

        {������������}

        for TLP in DrawPoints do
        begin
             Canvas.Stroke.Color := TLP.Color;      { �F���ݒ�ǉ� }
             case TLP.Status of
                        sStart : StartPoint := TLP.Positon;
                else
                        begin
                            Canvas.DrawLine(StartPoint, TLP.Positon, 1, Canvas.Stroke);
                            StartPoint := TLP.Positon;
                        end;
                end;
        end;
end;


procedure TMainForm.ColorClick(Sender: TObject);
begin
  SelectColor := (Sender as  TRectangle).Fill.Color;
end;

end.
