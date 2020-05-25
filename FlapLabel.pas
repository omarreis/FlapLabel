unit FlapLabel;      // good old mechanical airport display component ---------------\
 //-----------------//                                                                \
// portado de Unit FlapLabel; {airport style Flap label}                               \
// (c) 2002 Omar F Reis                                                                |
// Nota 18/4/02 - Para evitar ter que buscar o Caption (from e to) a cada transicao,   |
// o que tornava a coisa lenta eu salvei os index dos Caption (to e from).             |
// Se chegar no destino antes, ou se chegar em fIxTo e o                               |
// CaptionTo nao estiver mais lá, faz nova procura. Isto                               |
// pq novos itens podem estar sendo enfiados durante o flaps de um texto               |
// p/ outro. (embora isso seja pouco frequente)..                                      |
// O algoritmo para as transicoes funciona assim:                                      |
// 1) Quando ocorre uma alteracao do Caption (SetCaption):                             |
//    - Cria FlapEntry p/ o novo caption (i.e. o BMP), caso ainda nao exista.          |
//    - Seta fCaption com o Value                                                      |
//    - Seta fIxFrom - Index do BMP atual                                              |
//    - Seta fIxTo   - Index do proximo BMP na transicao                               |
// 2) A cada tick do clock:                                                            |
//    - Se flappando, faz uma transicao de estado (1 a 4)                              |
//    - Se estado=4, prepara para a proxima transicao                                  |
//    Invalida o BMP e o controle. A renderizacao do fControlBMP                       |
//    é feita dentro do Paint (só se necessario)                                       |
//                                                                                     |
// Historico:                                                                          |
//  Om: abr11: Evitei renderizacao durante carregamento das props do controle          |
//  Om: abr16: Portei pra FMX                                                          |
//-------------------------------------------------------------------------------------+

interface

uses
  System.SysUtils, System.Classes, System.Types, System.UITypes, System.UIConsts,
  FMX.Types, FMX.Controls, FMX.Objects, FMX.StdCtrls, FMX.Graphics;

const
  // flap label speed control. Global speed for all flaps
  FLAP_TIMER_INTERVAL = 25;   //1000;

type
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32 or pidiOSDevice32 or pidiOSDevice64 or pidiOSSimulator or pidAndroid or pidAndroid64Arm)]
    // TFlapCharSet - global flap flap charsets
   // - display image, w/ frames in table disposition (cols x rows)
  // - charset string (for single char plates)
 // - image parameters (frame size, frame count, num rows/cols
  TFlapCharSet= class(TComponent) // os rolos de flaps
  private
    fAirportCharset: String;  //one char for each frame, corresponding to the display src bmp
    FCharsetBMP: TBitmap;     //charset png, frames in table disposition
    fRowCount: integer;       //frame disposition in source bmp
    fColCount: integer;
    fFrameCount: integer;     //
    fFrameWidth,fFrameHeight:integer;     // single frame size
    procedure SetCharsetBMP(const Value: TBitmap);
    procedure SetFrameCount(const Value: integer);
    procedure SetRowCount(const Value: integer);
    procedure SetFrameHeight(const Value: integer);
    procedure SetFrameWidth(const Value: integer);
    procedure SetColCount(const Value: integer);
    function  getCharPositionInCharset(ix: integer; var LeftPos,  TopPos: Single): boolean;
    procedure SetAirportCharset(const Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function    getFrameBitmap(aFrame: Integer; aBackColor: TAlphaColor): TBitmap; //manufactures a frame bitmap (must be discarded by owner)
    function    c2index(c: char): integer;
    function    RandomChar: Char;
  published
    // char set params
    property    AirportCharset:String    read fAirportCharset  write SetAirportCharset;
    property    CharsetBMP: TBitmap      read FCharsetBMP      write SetCharsetBMP;
    property    FrameCount:integer       read fFrameCount      write SetFrameCount;
    property    RowCount:integer         read fRowCount        write SetRowCount default 1;
    property    ColCount:integer         read fColCount        write SetColCount default 1;
    property    FrameWidth:integer       read fFrameWidth      write SetFrameWidth;
    property    FrameHeight:integer      read fFrameHeight     write SetFrameHeight;
  end;

  TFlapChar = class(TShape)   // single char flap label. 
  private
    FCurrent: TBitmap;          //double buffer

    fCurrentFrame:integer;      //index of current shown frame
    fNeedRebuild:boolean;
    fCaption: String;           // caption pode ser '9' ou 'New York'
    fIxFrom,fIxTo:integer;      // controle
    fTransitionState:integer;   // estado da transicao / flap animation frame 0..4
    fbGoDirect: boolean;        // shortcut for speed
    fIsFlapping: boolean;
    fCharSet: TFlapCharSet;     // plate roll

    procedure SetCurrentFrame(const Value: integer);
    procedure RebuildCurrentBMP;  //rebuild dbl buffer
    procedure SetCaption(const Value: String);
    procedure FlapCharTimerTick(Sender: TObject);
    procedure SetCharset(const Value: TFlapCharSet);
    procedure startFlappingToCaption;
  protected
    procedure Paint; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function    PointInObjectLocal(X, Y: Single): Boolean; override;
    function    PointInObject(X, Y: Single): Boolean; override;
    Property    bGoDirect:boolean  read fbGoDirect write fbGoDirect default FALSE; //se bGoDirect, faz um flap direto pro destino (fast)
    Property    IsFlapping:boolean read fIsFlapping;
  published
    property CharSet:TFlapCharSet     read fCharSet         write SetCharset;
    property Frame:integer            read fCurrentFrame    write SetCurrentFrame;
    property Caption:String           read fCaption         write SetCaption;

    //expose hidden props
    property Align;
    property Width; //  default 60;
    property Height; // default 50;
    property HitTest default true;
    property Padding;
    property Opacity;
    property ClipParent;
    property ClipChildren;
    property Margins;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property Anchors;
    // property DesignVisible default True;
    property Enabled default True;
    property Locked default False;
    property TouchTargetExpansion;
    property Visible default True;
    property TabOrder;
    // property OnDragEnter;
    // property OnDragLeave;
    // property OnDragOver;
    // property OnDragDrop;
    // property OnDragEnd;
    // property OnKeyDown;
    // property OnKeyUp;
    // property OnCanFocus;
    // property OnEnter;
    // property OnExit;
    property OnClick;
    // property OnDblClick;
    property OnMouseDown;
    // property OnMouseMove;
    // property OnMouseUp;
    // property OnMouseWheel;
    // property OnMouseEnter;
    // property OnMouseLeave;
    property OnPainting;
    property OnPaint;
    property OnResize;
  end;

  TFlapLabel=class(TControl)  // set of chars (rolls that flap). Use Caption to change to change text
  private
    FHorizGap: integer;
    fCharSet: TFlapCharSet;
    fCaption: String;
    fFlapTextAlign:TTextAlign;
    fCountFlaps :integer;

    procedure SetHorizGap(const Value:integer);
    function  GetCountFlaps: integer;
    procedure SetCountFlaps(const Value: integer);
    procedure SetCaption(const Value: String);
    procedure SetCharset(const Value: TFlapCharSet);
    procedure Reposition;
    procedure CopyCaptionToFlaps;
  protected
    procedure DoRealign;                                 override;
    procedure DoAddObject(const AObject: TFmxObject);    override;
    procedure DoRemoveObject(const AObject: TFmxObject); override;
    procedure Resize;                                    override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    property CharSet:TFlapCharSet read fCharSet      write SetCharset;
    property CountFlaps:integer   read GetCountFlaps write SetCountFlaps;
    property Caption:String       read fCaption      write SetCaption;
    property HorizGap:integer     read FHorizGap     write SetHorizGap;
    property FlapTextAlign:TTextAlign read fFlapTextAlign   write fFlapTextAlign;

    // other
    property Align;
    property Anchors;
    property ClipChildren;
    property ClipParent;
    property Cursor;
    // property DesignVisible;
    property DragMode;
    // property EnableDragHighlight;
    property Enabled;
    property Locked;
    property Height;
    property HitTest;
    property Margins;
    property Opacity;
    property Padding;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property TouchTargetExpansion;
    property Visible;
    property Width;
    property OnApplyStyleLookup;
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnPainting;
    property OnPaint;
    property OnResize;
  end;

const sampleAirportCharset='ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.!?:';
// charset em \dpr4\flapflap\Images\AirportCharsetBMP.png
// 8 colunas x 5 linhas = 40 chars  PNG W=240 H=250  (cada char W=30 H=50)

type
  TGlobalFlapTimer=Class //timer global dos FlapLabels
  private
    fTimer:TTimer;
    fList:TList;       //of TFlapChar - global list of flaplabels
    // fLastTickCount:dword;    //usado para profile. Não implementado no FMX
    Procedure  GlobalTimeHit(Sender:TObject);
    function   GetCount:integer;
    function   GetInterval:cardinal;
    Procedure  SetInterval(value:cardinal);
    procedure  ClearEntryFromEntryTo;
    procedure  DoFlapTheLabels;
  public
    Constructor Create;
    Destructor  Destroy; Override;

    Property    Timer:TTimer read fTimer;
    Procedure   AddFlapChar(aFlapChar:TFlapChar);
    Procedure   DelFlapChar(aFlapChar:TFlapChar);
    Procedure   UpdateEnabled;
    Procedure   ForcaRenderizacaoDosFlaps;
    Property    Count:integer     read GetCount;
    Property    Interval:cardinal read GetInterval write SetInterval;
  end;

var
  GlobalFlapTimer:TGlobalFlapTimer=nil;
  bGlobalFlapEnabled:Boolean=true;                 //global turn flapping on-off (default=on)

procedure setFlapLabelsMode(value:boolean);  // true=go direct / false=regular slow flap flap flap mode (default)

procedure Register;

implementation //---------------------------------------------------------------

var
  numFlapEntries:integer=0;
  totBMPs:integer=0;
  CountFlapping:integer=0;
  //vars de controle global dos flap labels
  bBuildingSlideShow:boolean=FALSE;      //se true, nao anda conforme o timer, e sim de acordo com SlideshowTick
  bGradientBackground:boolean=true;     // nov07: Om: Apple style  bg nos flap labels
  GlobalSubtextFrame:integer;          //usado para sincronizar os flaps dos subtexts
  bDefaultFlapMode:boolean=false;     // true = goDirect  false=normal flat flap flap.. mode

// all or nothing
procedure setFlapLabelsMode(value:boolean);  // true=go direct / false=regular slow flap flap flap mode (default)
var i:integer; aFlapChar:TFlapChar;
begin
  if Assigned(GlobalFlapTimer) then
    begin
      bDefaultFlapMode := value;  //save default mode for future flaps
      for i:=0 to GlobalFlapTimer.fList.Count-1 do //change existing
        begin
          aFlapChar := TFlapChar(GlobalFlapTimer.fList.Items[i]);
          // aFlapChar.RenderCaption; ??
          aFlapChar.bGoDirect := value;
        end;
    end;
end;

{ TFlapChar }

constructor TFlapChar.Create(AOwner: TComponent);
begin
  inherited;
  fCharSet := nil;   //creation method ??

  FCurrent        := TBitmap.Create(0, 0);
  fCurrentFrame   := 0;
  fNeedRebuild:=true;

  fCaption := '';
  fIxFrom:=-1; //NF
  fIxTo:=-1;
  fTransitionState:=0;
  fbGoDirect  := bDefaultFlapMode;      // get from global. default = false
  fIsFlapping := false;
  // on demand create global timer, if needed.
  if not Assigned(GlobalFlapTimer) then
    GlobalFlapTimer:=TGlobalFlapTimer.Create;
  GlobalFlapTimer.AddFlapChar(Self); //Add self to timer global
end;

destructor TFlapChar.Destroy;
begin
  GlobalFlapTimer.DelFlapChar(Self);

  FreeAndNil(FCurrent);
  inherited;
end;

// RebuildCurrentBMP - rebuild dbl buffer, using:

procedure TFlapChar.RebuildCurrentBMP;   // render plate to FCurrent
var TopPos,LeftPos:Single; SR,DR:TRectF;
    SH2,SH4,SH,DH2,DH4,DH,ixA,ixB:integer;

  Procedure DrawFlapFrame(aH:integer); // no range de alturas (H2..aH) - H2 é o centro
  var aR:TRectF;
  begin
    if True then begin  //disabled
      fCurrent.Canvas.Stroke.Color := claGray;
      aR := RectF(0,DH2,Width-1,aH);
      fCurrent.Canvas.DrawRect(aR,0,0,AllCorners, 0.2); //very light frame, while moving
    end;
  end;

begin {RebuildCurrentBMP}
  if not Assigned(fCharSet) then exit;  //sanity test. must have a charset to paint
  // memoise numbers used frequently
  // fCurrent dbl buffer dimensions
  DH := Trunc(Height);    //component height
  DH2:= DH div 2; //valores usados com frequencia... altura/2
  DH4:= DH div 4; // e altura/4
  // source (charset) bmp
  SH := Trunc(fCharSet.FrameHeight);  //char set height
  SH2:= SH div 2;
  SH4:= SH div 4;

  fCurrent.SetSize(Trunc(Width),Trunc(Height) );  //just in case

  if fIsFlapping then  // control in in transition between frames.
    begin
      //Nota: 18/4/02- Os CopyRect comentados abaixo foram removidos para otimizar.                //  +--------+
      //Como ficou, somente as partes modificadas do BMP de um estado par outro sao renderizadas   //  | _BBB _ |  B=novo, top
      ixA := fIxFrom;       //  bottom plate  velho (one at a time)                                //  |  B  B  |    upcoming
      ixB := fIxFrom+1;     //  top plate novo ( next )                                            //  +--------+
      if (ixB>=fCharSet.FrameCount) then ixB:=0;  //wrap ?                                         //  | _AAA_  |
      //                                                                                           //  | A   A  |  A=old, bot
      //                                                                                           //  +--------+
      FCurrent.Canvas.BeginScene;
      try
          case fTransitionState of
            0: begin
                 DrawFlapFrame(0);    //estado 0 - Só desenha a moldura na metade de cima (do anterior)
                 //fRepaintRect:=Rect(0,0,Width,Height);
               end;
            1: if (ixA>=0) and (ixB>=0)   then
               begin
                 // FCurrent.Canvas.Clear(0);
                 if fCharSet.getCharPositionInCharset(ixB,LeftPos,TopPos) then  //== 1/4 do novo no topo
                   begin
                     SR := RectF(LeftPos, TopPos, LeftPos+fCharSet.FrameWidth, TopPos+SH4);
                     DR := RectF(0, 0, FCurrent.Width, DH4);
                     FCurrent.Canvas.DrawBitmap( fCharSet.CharsetBMP,SR,DR, 1);     // copia bmp do charset pro dbl buffer
                   end;
                 if fCharSet.getCharPositionInCharset(ixA,LeftPos,TopPos) then //== 3/4 do velho depois
                   begin
                     SR := RectF(LeftPos, TopPos, LeftPos+fCharSet.FrameWidth, TopPos+SH2);  //1/2 de cima do veio
                     DR := RectF(0, DH4, FCurrent.Width, DH2);                       // no 2o 1/4
                     FCurrent.Canvas.DrawBitmap( fCharSet.CharsetBMP,SR,DR, 1);     // copia bmp do charset pro dbl buffer

                     SR := RectF(LeftPos, TopPos+SH2, LeftPos+fCharSet.FrameWidth, TopPos+SH);
                     DR := RectF(0, DH2, FCurrent.Width, DH);                       // 1/2 de bx do veio na 1/2 do buffer
                     FCurrent.Canvas.DrawBitmap( fCharSet.CharsetBMP,SR,DR, 1);     // copia bmp do charset pro dbl buffer
                   end;
                 DrawFlapFrame(DH4);
               end;
            2: if (ixA>=0) and (ixB>=0)   then //== novo e velho 1/2 a 1/2
               begin
                 if fCharSet.getCharPositionInCharset(ixB,LeftPos,TopPos) then  //1/2 novo no topo
                   begin
                     SR := RectF(LeftPos, TopPos, LeftPos+fCharSet.FrameWidth, TopPos+SH2);
                     DR := RectF(0, 0, FCurrent.Width, DH2);
                     FCurrent.Canvas.DrawBitmap( fCharSet.CharsetBMP,SR,DR, 1);     // copia bmp do charset pro dbl buffer
                   end;
                 if fCharSet.getCharPositionInCharset(ixA,LeftPos,TopPos) then //== 1/2 do velho embaixo
                   begin
                     SR := RectF(LeftPos, TopPos+SH2, LeftPos+fCharSet.FrameWidth, TopPos+SH);
                     DR := RectF(0, DH2, FCurrent.Width, DH);
                     FCurrent.Canvas.DrawBitmap( fCharSet.CharsetBMP,SR,DR, 1);     // copia bmp do charset pro dbl buffer
                   end;
                 DrawFlapFrame(DH2);
               end;
            3: if (ixA>=0) and (ixB>=0)  then //== 1/4 do velho em baixo
               begin
                 if fCharSet.getCharPositionInCharset(ixB,LeftPos,TopPos) then  //1/2 do novo no topo
                   begin
                     SR := RectF(LeftPos, TopPos, LeftPos+fCharSet.FrameWidth, TopPos+SH2);
                     DR := RectF(0, 0, FCurrent.Width, DH2);
                     FCurrent.Canvas.DrawBitmap( fCharSet.CharsetBMP,SR,DR, 1);     // copia bmp do charset pro dbl buffer
                   end;
                 if False then     //reflexo ou
                   begin          //reflexo cinza
                     DR := RectF(0,DH2,Width,3*DH4);         // de 1/2 a 3/4 põe reflexo cinza
                     FCurrent.Canvas.Fill.Color := TAlphaColorRec.Cadetblue; //??
                     FCurrent.Canvas.FillRect(DR,0,0,AllCorners,1);
                   end
                   else begin
                     if fCharSet.getCharPositionInCharset(ixB,LeftPos,TopPos) then  // de 1/4 a 0.5 do novo embaixo
                       begin
                         SR := RectF(LeftPos, TopPos+SH2, LeftPos+fCharSet.FrameWidth, TopPos+SH);   // metade de baixo do ixA
                         DR := RectF(0,DH2,Width,3*DH4);                                       // no quarto de cima da metade de baixo
                         FCurrent.Canvas.DrawBitmap( fCharSet.CharsetBMP,SR,DR, 1);     // copia bmp do charset pro dbl buffer
                       end;
                   end;

                 if fCharSet.getCharPositionInCharset(ixA,LeftPos,TopPos) then  // de 3/4 a 1 do velho embaixo
                   begin
                     SR := RectF(LeftPos, TopPos+SH2+SH4, LeftPos+fCharSet.FrameWidth, TopPos+SH);
                     DR := RectF(0, +DH2+DH4, FCurrent.Width, DH);
                     FCurrent.Canvas.DrawBitmap( fCharSet.CharsetBMP,SR,DR, 1);     // copia bmp do charset pro dbl buffer
                   end;

                 //fRepaintRect:=RT;
                 DrawFlapFrame(3*DH4);
               end;
             4: if (ixB>=0) then //== 100% novo ( o bmp anterior desaparece)
               begin
                 if fCharSet.getCharPositionInCharset(ixB,LeftPos,TopPos) then  //100% do novo
                   begin
                     SR := RectF(LeftPos, TopPos, LeftPos+fCharSet.FrameWidth, TopPos+SH);
                     DR := RectF(0, 0, FCurrent.Width, DH);
                     FCurrent.Canvas.DrawBitmap( fCharSet.CharsetBMP,SR,DR, 1);     // copia bmp do charset pro dbl buffer
                   end;
               end;
          else  //?? not supposed to happen..
             // if (ixB>=0) and getCharPositionInCharset(ixB,LeftPos,TopPos) then  //100%
             //   begin
             //     fCurrentFrame := ixB;    //completed a rendering cycle
             //     fIxFrom       := ixB;
             //     SR := RectF(LeftPos, TopPos, LeftPos+FCurrent.Width, TopPos+H);
             //     DR := RectF(0, 0, FCurrent.Width, H);
             //     FCurrent.Canvas.DrawBitmap( FCharsetBMP,SR,DR, 1);     // copia bmp do charset pro dbl buffer
             //   end;
          end;
          fNeedRebuild:=false; //
      finally
        fCurrent.Canvas.EndScene;
      end;
    end
    else begin   //not flaping. show current frame
      FCurrent.Canvas.BeginScene;
      try
        ixA := fCurrentFrame;
        if (ixA>=0) and fCharSet.getCharPositionInCharset(ixA,LeftPos,TopPos) then  //100%
           begin
             SR := RectF(LeftPos, TopPos, LeftPos+fCharSet.FrameWidth, TopPos+SH);
             DR := RectF(0, 0, FCurrent.Width, DH);
             FCurrent.Canvas.DrawBitmap( fCharSet.CharsetBMP,SR,DR, 1);     // copia bmp do charset pro dbl buffer
             fNeedRebuild:=false; //
           end;
      finally
        fCurrent.Canvas.EndScene;
      end;
    end;
end;

procedure TFlapChar.Paint;
var aRect:TRectF;
begin
  if fNeedRebuild then
    begin
      RebuildCurrentBMP;
      fNeedRebuild:=false;
    end;
  aRect:=RectF(0,0,fCurrent.Width,fCurrent.Height);
  Canvas.BeginScene;
  try
    Canvas.DrawBitmap(fCurrent,aRect, aRect,1);
  finally
    Canvas.EndScene;
  end;
end;

function TFlapChar.PointInObject(X, Y: Single): Boolean;
var P: TPointF;
begin
  P := AbsoluteToLocal(PointF(X, Y));
  Exit(PointInObjectLocal(P.X, P.Y));
end;

function TFlapChar.PointInObjectLocal(X, Y: Single): Boolean;
begin
  Result := (x>=0) and (x<Width) and (y>=0) and (y<Height);
end;

procedure TFlapChar.Resize;
begin
  inherited;
  fNeedRebuild:=true;
  Repaint;
end;

procedure TFlapChar.FlapCharTimerTick(Sender:TObject); //handler de tick do timer global
begin
  if (fIxTo<0) or  (not Assigned(fCharSet)) or   // fIxTo=-1 -->invalid, not flapping. Also need a charset
     (fIxTo>=fCharSet.FrameCount) then exit;     // sanity test fIxTo. nada
  //era: if not Assigned(fEntryTo) then exit;  //se nao tem fEntryTo, nao está flappando.
  //aqui tem que procurar o entry em cada tick, pois outro TFlapLabel pode ter alterado a lista :-(

  if fIsFlapping then  //is in transition between plates.
    begin
      inc(fTransitionState);          //still flapping. goto next state.
      if (fTransitionState>4) then   //terminou um ciclo. Prepara proximo par de frames ...
         begin
           if (fIxFrom=fIxTo) then  //chegou no fCaption solicitado ?
             begin
               fCurrentFrame := fIxTo;   //save current.
               fIsFlapping:=FALSE;      //Pára as transicoes (fTransitionState fica no 4)
               //fIxTo := -1;          //isso para a flapagem
             end
             else begin                  //prepara proxima transicao
               inc(fIxFrom);             //next
               if (fIxFrom>=fCharSet.FrameCount) then fIxFrom:=0; //wrap
               if (fIxFrom=fIxTo) then
                 begin
                   fCurrentFrame := fIxTo;  //
                   fIsFlapping:=FALSE;      //Sim. Pára as transicoes (fTransitionState fica no 4)
                 end
                 else begin
                   fIsFlapping     := TRUE;  //keep true
                   fTransitionState:=0;      //start over
                 end;
             end;
         end;
      fNeedRebuild:=true;                        //make sure we redraw the ControlBMP on the next Paint
    end;

  if fNeedRebuild then Repaint;     //and make sure we do a Paint if visible
end;

procedure TFlapChar.startFlappingToCaption;
var c:Char; aIxFrame,ixa:integer;
begin
  if (fCaption<>'') and Assigned(fCharSet) then     //not null
    begin
      c        := Upcase(fCaption[Low(fCaption)]);   //use only 1st char (if more)
      aIxFrame := fCharSet.c2index(c);              //find char corresponding to Caption[1]
      // aIxFrame aponta o target da flappagem
      if (aIxFrame>=0) and (aIxFrame<fCharSet.FrameCount)   then  //found
        begin
          if fbGoDirect then //..começa a flapar um antes do target atual (Isso faz um flap rápido)
            begin
              ixa := aIxFrame-1;  //start from pervious
              if (ixa<0) then ixa := fCharSet.FrameCount-1;   // ix tem o novo caption, pega o anterior  ..
              fCurrentFrame := ixa;
            end
            else ixa := fCurrentFrame;      //start from current
          fIxFrom       := ixa;
          fIxTo         := aIxFrame;  //destination frame
          if (fIxFrom=fIxTo) then  //if fIxFrom=fIxTo, nothing to do
            begin
            end
            else begin                 //otherwise, start flapping towards the new caption
              fTransitionState := 0;  //prepara para nova transicao
              fIsFlapping      := TRUE;
              GlobalFlapTimer.Timer.Enabled := TRUE; //start global timer, just in case
            end;
         // Frame := aIxFrame;   //this changes the control content
        end;
    end;
end;

procedure TFlapChar.SetCaption(const Value: String);
begin
  if (fCaption<>Value) then
    begin
      fCaption := Value;
      startFlappingToCaption;
    end;
end;

procedure TFlapChar.SetCharset(const Value: TFlapCharSet);
begin
  if (fCharSet<>Value) then
    begin
      fCharSet := Value;
      if Assigned(fCharSet) then
        startFlappingToCaption;
    end;
end;

procedure TFlapChar.SetCurrentFrame(const Value: integer);
begin
  if (fCurrentFrame<>Value) and (Value>=0) and Assigned(fCharSet) and  (Value<fCharSet.FrameCount) then
    begin
      fCurrentFrame := Value;
      fNeedRebuild:=true;
      // Repaint;
    end;
end;

{ TGlobalFlapTimer }
Constructor TGlobalFlapTimer.Create;
begin
  inherited;
  fTimer:=TTimer.Create(nil);
  fTimer.Enabled:=FALSE;       //create disabled
  fTimer.Interval:= FLAP_TIMER_INTERVAL;   // <- flap interval
  fTimer.OnTimer := GlobalTimeHit;
  fList:=TList.Create;  // list of flaps
  //fLastTickCount:=GetTickCount;
end;

Destructor  TGlobalFlapTimer.Destroy;
begin
  fTimer.Free;
  fList.Free;
  inherited;
end;

Procedure   TGlobalFlapTimer.AddFlapChar(aFlapChar:TFlapChar);
begin
  fList.Add(aFlapChar);
end;

Procedure TGlobalFlapTimer.ForcaRenderizacaoDosFlaps;
var i:integer; aFlapChar:TFlapChar;
begin
  for i:=0 to fList.Count-1 do
    begin
      aFlapChar := TFlapChar(fList.Items[i]);
      // aFlapChar.RenderCaption; ??
    end;
end;

Procedure   TGlobalFlapTimer.ClearEntryFromEntryTo;
var i:integer; aFlapChar:TFlapChar;
begin
  for i:=0 to fList.Count-1 do
    begin
      aFlapChar:=TFlapChar(fList.Items[i]);
      //aFlapChar.fEntryFrom:=nil;
      //aFlapChar.fEntryTo:=nil;
      aFlapChar.fIxFrom:=-1; //NF (New flap strategy...)
      aFlapChar.fIxTo:=-1;
    end;
end;

Procedure   TGlobalFlapTimer.DelFlapChar(aFlapChar:TFlapChar);
begin
  fList.Remove(aFlapChar);
end;

//esse é o handler do ticker global
Procedure  TGlobalFlapTimer.DoFlapTheLabels;
var i:integer; aFlapChar:TFlapChar; //bFallingBehind:boolean; ElapsedTime,T:dword;
begin
  // T := GetTickCount;
  //ElapsedTime:=T-fLastTickCount;
  //MostraIntVar(1,ElapsedTime);
  // if bBuildingSlideShow then bFallingBehind:=FALSE
  //   else bFallingBehind:=(ElapsedTime)>(4*Interval); //falling bad behind timer Interval, cut the flapping shit..
  // fLastTickCount:=T;
  CountFlapping:=0;
  inc(GlobalSubtextFrame);
  for i:=0 to fList.Count-1 do
    begin
      aFlapChar := TFlapChar(fList.Items[i]);
      if aFlapChar.IsFlapping then
        begin
          inc(CountFlapping);
          // if bFallingBehind and bStopFlappingIfFallingBehind then aFlapChar.FallingBehind else
          aFlapChar.FlapCharTimerTick(Self);
        end;
        // else aFlapChar.SubTextTick;  //ve se tem subtext pra rodar
      // aFlapChar.AvancaSubtextFrame;
    end;
  if (CountFlapping=0) then fTimer.Enabled := false; //stop timer if none flapping
end;

Procedure   TGlobalFlapTimer.GlobalTimeHit(Sender:TObject);
begin
  if (not bBuildingSlideShow) and
      bGlobalFlapEnabled then
        DoFlapTheLabels;       //do the flapping thing
end;

function   TGlobalFlapTimer.GetCount:integer;
begin Result:=fList.Count; end;

procedure TGlobalFlapTimer.UpdateEnabled;
var i:integer; bEnabled:boolean;
begin
  bEnabled:=FALSE;
  for i:=0 to fList.Count-1 do
    if TFlapChar(fList.Items[i]).IsFlapping then
      begin
        bEnabled:=TRUE;
        break;
      end;
  fTimer.Enabled := bEnabled;   //mk global timer run if at least 1 digit is flapping
end;

function TGlobalFlapTimer.GetInterval: cardinal;
begin
  Result:=fTimer.Interval;
end;

procedure TGlobalFlapTimer.SetInterval(value: cardinal);
begin
  if (value<>fTimer.Interval) then
    begin
      fTimer.Interval:=value;
      fTimer.Enabled:=(value<>0);
    end;
end;

{ TFlapCharSet }

constructor TFlapCharSet.Create(AOwner: TComponent);
begin
  inherited;
  fFrameWidth :=0;      //make sure you set all these before using this!!
  fFrameHeight:=0;      //frame size
  fFrameCount :=0;
  fRowCount   :=1;
  fColCount   :=1;
  FCharsetBMP := TBitmap.Create(0, 0); //create empty
  fAirportCharset := '';
end;

destructor TFlapCharSet.Destroy;
begin
  FreeAndNil(FCharsetBMP);
  inherited;
end;

procedure TFlapCharSet.SetAirportCharset(const Value: String);
begin
  fAirportCharset := Value;
end;

procedure TFlapCharSet.SetColCount(const Value: integer);
begin
  if (Value<>0) then
    fColCount := Value;
end;

procedure TFlapCharSet.SetCharsetBMP(const Value: TBitmap);
begin
  fCharsetBMP.Assign(Value);
  // fNeedRebuild:=true;  ??
end;

procedure TFlapCharSet.SetFrameCount(const Value: integer);
begin
  if (fFrameCount<>Value) then
    begin
      fFrameCount := Value;
      // if (fCurrentFrame>=fFrameCount) then fCurrentFrame:=0;
      // fNeedRebuild:=true;
      // Repaint;
    end;
end;

procedure TFlapCharSet.SetFrameHeight(const Value: integer);
begin
  fFrameHeight := Value;
end;

procedure TFlapCharSet.SetFrameWidth(const Value: integer);
begin
  fFrameWidth := Value;
end;

procedure TFlapCharSet.SetRowCount(const Value: integer);
begin
  fRowCount := Value;
end;

function TFlapCharSet.getCharPositionInCharset(ix:integer; var LeftPos,TopPos:Single):boolean;
var aRow,aCol:integer;
begin
  Result := false;
  if (ix>=0) and (ix<fFrameCount) and (fColCount<>0) then
    begin
      aCol := ix mod fColCount; aRow := ix div fColCount;
      LeftPos := aCol*fFrameWidth;    TopPos  := aRow*fFrameHeight;
      Result := true;
    end;
end;

//manufactures a frame bitmap (must be discarded by owner)
function TFlapCharSet.getFrameBitmap(aFrame:Integer; aBackColor: TAlphaColor):TBitmap;
var TopPos,LeftPos: Single; aRow,aCol:integer;
begin
  Result := TBitmap.Create;
  {$IFDEF AUTOREFCOUNT}
  Result.__ObjAddRef;    //so it doesn`t get wasted
  {$ENDIF AUTOREFCOUNT}
  Result.SetSize(Trunc(fFrameWidth),Trunc(fFrameHeight) );
  //calc top/left
  aRow := aFrame div fColCount;
  aCol := aFrame mod fColCount;

  LeftPos := aCol*fFrameWidth;
  TopPos  := aRow*fFrameHeight;
  if Result.Canvas.BeginScene then
  try
    Result.Canvas.Clear(aBackColor);
    Result.Canvas.DrawBitmap(fCharsetBMP,
       RectF(LeftPos, TopPos, LeftPos+fFrameWidth, TopPos+fFrameHeight),  //src
       RectF(0, 0, fFrameWidth, fFrameHeight),                            //dest
       1);
  finally
    Result.Canvas.EndScene;
  end;
end;

function TFlapCharSet.c2index(c:char):integer;   // char -->indx no chartset (0 base)
begin
  Result := Pos(c,fAirportCharset)-1;     // Pos() is 1 based. 0 -1 converte pra base 0
end;

function TFlapCharSet.RandomChar:Char;
begin
  Result := AirportCharset[ Random( Length(fAirportCharset) ) ];
end;

{ TFlapLabel }

constructor TFlapLabel.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );
  // use Controls como list of TFlapChars
  FHorizGap := 1;
  fCharSet  := nil;
  fCaption  := '';
  fFlapTextAlign := TTextAlign.Leading;
  fCountFlaps    := 0;
end;


destructor TFlapLabel.Destroy;
begin
  inherited;
end;

procedure TFlapLabel.DoAddObject(const AObject: TFmxObject);
begin
  inherited;
  //Reposition;
end;

procedure TFlapLabel.DoRealign;
begin
  inherited;
  //Reposition;
end;

procedure TFlapLabel.DoRemoveObject(const AObject: TFmxObject);
begin
  inherited;
  //Reposition;
end;

procedure TFlapLabel.Resize;
begin
  inherited;
  Reposition;          //auto adjust flaps to fit
end;

function TFlapLabel.GetCountFlaps: integer;
begin
  Result := fCountFlaps;  //Controls.Count;
end;

procedure TFlapLabel.SetCountFlaps(const Value: integer);
var i: Integer; aFlap:TFlapChar;
begin
  if (Value<>fCountFlaps) then
    begin
      fCountFlaps := Value;

      // Apaga anteriores
      for i := ControlsCount-1 downto 0 do  //remove all controls
        begin
          if (Controls[i] is TFlapChar) then
            begin
              aFlap := TFlapChar(  Controls[i] );
              Controls.Remove(aFlap);

              {$IFDEF AUTOREFCOUNT}
              aFlap.__ObjRelease;    //so it doesn`t get wasted.  CHECK: needed? possible memory loss...
              {$ELSE AUTOREFCOUNT}
              aFlap.Free;
              {$ENDIF AUTOREFCOUNT}
            end;
        end;
      Controls.Clear;           //clear previous

      for i := 0 to fCountFlaps-1 do  //recreate
        begin
          aFlap := TFlapChar.Create(Self);
          {$IFDEF AUTOREFCOUNT}
          aFlap.__ObjAddRef;    //so it doesn`t get wasted.  CHECK: needed? possible memory loss...
          {$ENDIF AUTOREFCOUNT}
          aFlap.Parent  := Self;              // this inserts
          aFlap.Stored  := false;
          aFlap.CharSet := fCharSet;          //use charset
          aFlap.Align   := TAlignLayout.None;
          aFlap.Index   := i;
          aFlap.Tag     := i;  //save ix
          //aFlap.Frame      := 3;
        end;
      Reposition;                    // fit flaps to layout dimensions
      CopyCaptionToFlaps;
    end;
end;

procedure TFlapLabel.Reposition;  // to fit control dimensions (autoresize flaps)
var aControl:TControl; w,h,n,nx:integer;
begin
  n := Controls.Count;
  if (n=0) then exit;  //nada
  h  := Trunc(Height);
  w  := Trunc( ((Width-Margins.Left-Margins.Right)/n)-fHorizGap );
  nx := Trunc(Margins.Left);
  FDisableAlign := True;
  try
    for aControl in Controls do
      if aControl.Visible then
        begin
           aControl.SetBounds(
             nx,              // x
             Margins.Top,    // y
             w,             // w
             h);           // h
           nx := nx+fHorizGap+w;
        end;
  finally
    FDisableAlign := False;
  end;
end;

procedure TFlapLabel.CopyCaptionToFlaps;
var i,n:Integer; aControl:TControl; c:char;
    s:String;
begin
  if Controls.Count=0 then exit; //no flaps to copy to (yet)
  n:=0;  //1st flap

  s := fCaption;
  if (fFlapTextAlign=TTextAlign.Trailing) then    // trailing text
    while (s.Length<CountFlaps) do s:=' '+s;      // pad with ' 's before

  for i := Low(s) to High(s) do   //um char por label
    begin
      c := s[i];
      //if (c=' ') then c:='.'; //TESTE
      if (n<Controls.Count) then
        begin
          aControl := Controls[n];
          if (aControl is TFlapChar) then       //must be true for all controls in the layout
            TFlapChar(aControl).Caption := c;
        end;
      inc(n); //next
    end;
  for i := n to Controls.Count-1 do       // põe spaces no final
     begin
       aControl := Controls[i];
       if (aControl is TFlapChar) then
         TFlapChar(aControl).Caption := ' ';  // Chartset MUST contain ' ' !
     end;
end;

procedure TFlapLabel.SetCaption(const Value: String);
begin
  if (fCaption<>Value) then
    begin
      fCaption := Value;
      CopyCaptionToFlaps;
    end;
end;

procedure TFlapLabel.SetCharset(const Value: TFlapCharSet);
var aControl:TControl;
begin
  fCharSet := Value;
  // copy to controls
  for aControl in Controls do
    if (aControl is TFlapChar)  then          //all should be
      TFlapChar(aControl).CharSet := Value;   //set/reset charset
  if Assigned(fCharSet) then  //setting a valid charset triggers flaps
    CopyCaptionToFlaps;
end;

procedure TFlapLabel.SetHorizGap(const Value: integer);
begin
  if Value<>FHorizGap then
    begin
      FHorizGap := Value;
      Reposition;
    end;
end;

{ ---- }

procedure Register;
begin
  RegisterComponents('Omar', [TFlapChar, TFlapCharSet, TFlapLabel]);  //causes error !?
  RegisterClasses([TFlapChar, TFlapCharSet, TFlapLabel]);
end;

initialization
  // Register;     //need to work with styles
  RegisterFmxClasses([TFlapChar, TFlapCharSet, TFlapLabel]);
end.

