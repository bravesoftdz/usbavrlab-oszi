[Defines]
#define AppName GetEnv('Progname')
#define AppVersion GetEnv('Version')
#define SetupDate GetEnv('DateStamp')
#define FullTarget GetEnv('FullTarget')
[Setup]
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
OutputBaseFilename=usbavrlaboszi_{#FullTarget}
DefaultDirName={pf}\{#AppName}
DefaultGroupName={#AppName}
UninstallDisplayIcon={app}\avrusblaboszi.exe

[Files]
Source: ..\..\output\i386-win32\avrusblaboszi.exe; DestDir: {app}; Components: main

Source: ..\..\languages\*.po; DestDir: {app}\languages; Components: main
Source: ..\..\languages\*.txt; DestDir: {app}\languages; Components: main

;Source: "..\..\..\Update\Output\i386-win32\update.exe"; DestDir: "{app}\update";Components: main
;Source: "..\..\..\Update\Tools\bspatch.exe"; DestDir: "{app}\update";Components: main
;Source: "..\..\..\Update\Tools\bzip2.exe"; DestDir: "{app}\update";Components: main
;Source: "..\..\..\Update\Tools\Binary diff.txt"; DestDir: "{app}\update";Components: main

Source: website.url; DestDir: {app}

;------ Copy Survey Extension (IssSurvey.dll) in your app install folder to use it on unistall
Source: IssSurvey.dll; DestDir: {app}
;------ Copy Survey Extension Language File (IssSurvey.ini) in your app install folder
Source: IssSurvey.ini; DestDir: {app}
;------

[Components]
Name: main; Description: Main Program Components; Languages: en; Types: full compact custom; Flags: fixed

Name: main; Description: Hauptprogramm Komponenten; Languages: de; Types: full compact custom; Flags: fixed

[Tasks]
Name: desktopicon; Description: Create an Desktop Icon; GroupDescription: Additional Icons:; Languages: en
Name: desktopicon; Description: Ein Desktop Icon erstellen; GroupDescription: Zusätzliche Icons:; Languages: de

[Icons]
Name: {group}\USB AVR-Lab Oszi; Filename: {app}\avrusblaboszi.exe; Workingdir: {app}
Name: {group}\Internet; Filename: {app}\website.url
Name: {userdesktop}\USB AVR-Lab Oszi; Filename: {app}\avrusblaboszi.exe; Tasks: desktopicon

[UninstallDelete]
Type: filesandordirs; Name: {app}

[Languages]
Name: en; MessagesFile: compiler:Default.isl
Name: de; MessagesFile: German.isl

[Code]
// IssSurvey function called on uninstall
function IssSurvey(Language: PChar; ReasonsList: PChar; Server: PChar; UserName: PChar; Password: PChar): Integer;
external 'IssSurvey@{app}\IssSurvey.dll stdcall uninstallonly';

//********************************************************************************************************************************************
// IssSurvey function returns: 0 if the user has submited the comments; 1 if cancel or close pressed; 2 if ignore/skip pressed; -1 if an error occured
//
//  Language    = IssSurvey language dialog. Set this value to empty '' and default english will be used
//                ( see and include IssSurvey.ini if you need custom text or other language)
//
//  ReasonsList  = Uninstall reasons templates list. Separate multiple reasons with semicolon.
//                 Set this value to empty string '' to hide the template reasons combo box and show only the edit box
//
//  Server      = Full http path to a php script. The IssSurvey will POST at this adresss the selected uninstall reason and any user feedback/comments.
//                Ex: 'http://raz-soft.com/IssSurvey/IssSurvey_mail.php'
//                Informations posted when the user submits the survey from IssSurvey Extension:
//                $name      = the name you pass on the IssSurvey Extension function     (for security purpose)
//                $pass      = the password you pass on the IssSurvey Extension function (for security purpose)
//                $cntinfo   = the user reason/comments/feedback. !!Warning: the sent text is base64 encoded.
//                $IssSurvey = just for a check control. It will be set to 1 by IssSurvey Extension
//
//  UserName   =  a user name to submit along with the reason/comments  (for security purpose)
//
//  Password   =  a password to submit along with the reason/comments  (for security purpose)
//
//******************************************************************************************************************************************


function InitializeUninstall(): Boolean;
var
  sReasons: String;
  nCode: Integer;  { 0 if the user has submited the comments; 1 if cancel or close pressed; 2 if ignore/skip pressed; -1 if an error occured }

begin
     Result   := false;
     sReasons := 'Ich verstehe die Bedienung dieses Programms nicht.;Ich mag das Programm nicht.;Ich kenne ein besseres Programm.;Anderer Grund (siehe unten):';
     nCode    := IssSurvey('de',sReasons,'http://update.ullihome.de/IssSurvey_mail.php','demo','demo');

     if (nCode=0) or (nCode=2) then begin                    { submited or ignored }
          Result := true;                                    { continue uninstall setup      }
     end;

    // Unload the extension, otherwise it will not be deleted by the uninstaller
    UnloadDLL(ExpandConstant('{app}\IssSurvey.dll'));

end;
