{
+----------------------------------------------------------------------+
| This program is free software; you can redistribute it and/or modify |
| it under the terms of the GNU General Public License as published by |
| the Free Software Foundation; version 2 of the License.              |
|                                                                      |
| This program is distributed in the hope that it will be useful,      |
| but WITHOUT ANY WARRANTY; without even the implied warranty of       |
| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the         |
| GNU General Public License for more details.                         |
+----------------------------------------------------------------------+
| Copyright (c) 2010..2024 - J. Aldo G. de Freitas Junior              |
+----------------------------------------------------------------------+
}

{$mode objfpc}
{$H+}

/// <summary>
/// Custom exception class for handling errors with row and column information.
/// </summary>
Unit BaseException;

Interface

Uses
  Classes, SysUtils;

Type
  /// <summary>
  /// Custom exception class for handling errors with row and column information.
  /// </summary>
  TRowColException = Class(Exception)
  Private
    FFileName: String;
    FRow: Integer;
    FCol: Integer;
  Public
    /// <summary>
    /// Initializes a new instance of the TRowColException class with a message, row, column, and optional file name.
    /// </summary>
    /// <param name="AMessage">The error message to be displayed.</param>
    /// <param name="ARow">The row number where the error occurred.</param>
    /// <param name="ACol">The column number where the error occurred.</param>
    /// <param name="AFileName">Optional parameter specifying the file name where the error occurred.</param>
    Constructor Create(const AMessage: String; ARow, ACol: Integer; const AFileName: String = ''); overload;
    
    /// <summary>
    /// Initializes a new instance of the TRowColException class with a formatted message, row, column, and optional file name.
    /// </summary>
    /// <param name="AFormat">The format string for the error message.</param>
    /// <param name="Args">Arguments for formatting the message string.</param>
    /// <param name="ARow">The row number where the error occurred.</param>
    /// <param name="ACol">The column number where the error occurred.</param>
    /// <param name="AFileName">Optional parameter specifying the file name where the error occurred.</param>
    Constructor CreateFmt(const AFormat: String; const Args: Array of const; ARow, ACol: Integer; const AFileName: String = ''); overload;
    
    /// <summary>
    /// Provides a string representation of the exception, including the message, file name, row, and column.
    /// </summary>
    /// <returns>
    /// A string that represents the current exception.
    /// </returns>
    Function ToString: String; Override;
    
    /// <summary>
    /// Gets or sets the file name where the error occurred.
    /// </summary>
    Property FileName: String Read FFileName Write FFileName;
    
    /// <summary>
    /// Gets or sets the row number where the error occurred.
    /// </summary>
    Property Row: Integer Read FRow Write FRow;
    
    /// <summary>
    /// Gets or sets the column number where the error occurred.
    /// </summary>
    Property Col: Integer Read FCol Write FCol;
  End;

Implementation

Constructor TRowColException.Create(const AMessage: String; ARow, ACol: Integer; const AFileName: String = '');
Begin
  Inherited Create(AMessage);
  FRow := ARow;
  FCol := ACol;
  FFileName := AFileName;
End;

Constructor TRowColException.CreateFmt(const AFormat: String; const Args: Array of const; ARow, ACol: Integer; const AFileName: String = '');
Begin
  Inherited CreateFmt(AFormat, Args);
  FRow := ARow;
  FCol := ACol;
  FFileName := AFileName;
End;

Function TRowColException.ToString: String;
Begin
  If FFileName <> '' Then
    Result := Format('%s (File: %s, Line: %d, Col: %d)', [Message, FFileName, FRow, FCol])
  Else
    Result := Format('%s (Line: %d, Col: %d)', [Message, FRow, FCol]);
End;

End.
