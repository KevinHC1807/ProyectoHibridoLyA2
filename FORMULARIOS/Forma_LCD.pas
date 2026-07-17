unit Forma_LCD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls,MMSystem,ShellAPI;

type
  TFormaLCD = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    editPrograma: TEdit;
    editTexto: TEdit;
    MemoASM: TMemo;
    laHora: TLabel;
    Button1: TButton;
    Image3: TImage;
    Label4: TLabel;
    Exportar: TButton;
    procedure Button1Click(Sender: TObject);
    procedure ExportarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    emu86, enter, APOSTROFE, INICIO, FIN, programa: String;
    Archivo: TextFile;
    prog, mensaje: String;
  end;

var
  FormaLCD: TFormaLCD;

implementation

{$R *.dfm}

procedure TFormaLCD.Button1Click(Sender: TObject);
begin
 close;
end;

procedure TFormaLCD.ExportarClick(Sender: TObject);
begin
  Try
        // 1. Corrección: Añadida la barra inclinada '\' que faltaba en la ruta
        prog := 'C:\Users\kevin\Downloads\' + EditPrograma.Text + '.asm';
        mensaje := EditTexto.Text;

        IF (Length(prog) <> 0) AND (Length(mensaje) <> 0) THEN
        BEGIN

            emu86 := '.MODEL SMALL' + ENTER +
                    '.STACK' + ENTER +
                    '.DATA' + ENTER +
                    'CADENA DB ' + APOSTROFE +
                    EditTexto.Text + APOSTROFE + ENTER +
                    '.CODE' + ENTER + ENTER +
                    INICIO + ENTER + ENTER +
                    'MOV DX,2040H' + ENTER +
                    'MOV SI,0' + ENTER +
                    'MOV AL,CADENA[SI]' + ENTER +
                    'OUT DX,AL' + ENTER + FIN;

            // CREACION DE ARCHIVOS
            AssignFile(Archivo, prog);
            Rewrite(Archivo);
            Write(Archivo, emu86);
            laHora.Caption := 'Hora de envio ' + TimeToStr(now);
            sndPlaySound('C:\Users\kevin\OneDrive\Desktop\LYA2 PROYECTOS\PROYECTO HIBRIDO MULTIPLATAFORMA\SONIDO\new-notification-022-370046.wav', SND_FILENAME OR SND_ASYNC);
            closeFile(Archivo);
            MemoAsm.Lines.LoadFromFile(prog);

            // 3. Corrección: 'Handle' corregido y punto cambiado por coma antes de SW_SHOWNORMAL
            shellExecute(Handle, nil, pChar(prog), nil, nil, SW_SHOWNORMAL);
        END // <-- CORRECCIÓN: Se quitó el punto y coma (;) antes del ELSE
        ELSE
        BEGIN
            ShowMessage('Favor de proporcionar los datos');
        END;
    except
        showMessage('Error al generar el archivo LCD .asm');
    End; // fin try
end;

procedure TFormaLCD.FormActivate(Sender: TObject);
begin
  enter:=#13#10;
  APOSTROFE:='''';
  INICIO:='MOV AX,@DATA' + ENTER +
          'MOV DS,AX' + ENTER;

  FIN:= 'MOV AX,4C00H' + ENTER +
        'INT 21H' + ENTER +
        'END';
  Programa:='';
end;

end.
