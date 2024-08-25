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

/// <summary> Represents a collection of tabular data with headers and
/// rows.
/// </summary>
Unit
  TabularData;

Interface

Uses
  SysUtils, Classes, Generics.Collections;

Type
  /// <summary> TTabularData is a class that manages tabular data, allowing
  /// users to dynamically add headers and rows, and output the data in a
  /// formatted manner.
  /// </summary>
  TTabularData = Class
  Private
    /// <summary> Stores the tabular data as a dictionary, where each key is
    /// a header, and the associated value is a list of strings representing
    /// the data for that column.
    /// </summary>
    fData: TDictionary<String, TList<String>>;
    /// <summary> A list of headers, representing the columns in the table.
    /// </summary>
    fHeaders: TStringList;
  Public
    /// <summary> Initializes a new instance of the TTabularData class.
    /// Allocates memory for the internal data structures.
    /// </summary>
    Constructor Create;

    /// <summary> Destroys the TTabularData instance, releasing memory.
    /// Cleans up the data structures and ensures that all allocated memory
    /// is properly freed.
    /// </summary>
    Destructor Destroy; Override;

    /// <summary> Clears all data from the collection.
    /// Removes all rows of data and headers, effectively resetting the
    /// tabular data.
    /// </summary>
    Procedure Clear;

    /// <summary> Adds a new header to the collection.
    /// </summary>
    /// <param name="aHeader">The header name to add
    /// </param>
    /// <remarks>
    /// If the header already exists, it is not added again. This ensures
    /// that the table does not have duplicate columns.
    /// </remarks>
    Procedure AddHeader(Const aHeader: String);

    /// <summary> Sets data in the specified column and row.
	/// </summary>
	/// <param name="aHeader">The header name of the column
	/// </param>
	/// <param name="aData">The data to insert into the column
	/// </param>
	/// <remarks>
	/// If the header does not exist, it is added automatically. The data
	/// is appended to the corresponding column's list of strings.
	/// </remarks>
    Procedure SetData(Const aHeader, aData: String);

    /// <summary> Formats the tabular data as a string for output.
	/// </summary>
	/// <remarks>
	/// This method dynamically calculates column widths and formats the
	/// data into a human-readable string. The output string will have
	/// columns aligned based on the maximum width of the data in each
	/// column.
	/// </remarks>
	/// <returns>A string containing the formatted tabular data
	/// </returns>
    Function PrintData: String;
  End;

Implementation

/// <summary> Initializes a new instance of the TTabularData class.
/// </summary>
Constructor TTabularData.Create;
Begin
  Inherited Create;
  // Initialize the dictionary to store column data
  fData := TDictionary<String, TList<String>>.Create;
  // Initialize the list of headers
  fHeaders := TStringList.Create;
End;

/// <summary> Destroys the TTabularData instance, releasing memory.
/// </summary>
Destructor TTabularData.Destroy;
Var
  Header: String;
Begin
  // Free memory occupied by lists within the dictionary
  For Header In fData.Keys Do
    fData[Header].Free;
  // Free the dictionary itself
  fData.Free;
  // Free the list of headers
  fHeaders.Free;
  Inherited Destroy;
End;

/// <summary> Clears all data from the collection.
/// </summary>
Procedure TTabularData.Clear;
Var
  Header: String;
Begin
  // Iterate over all headers and clear the data associated with each column
  For Header In fData.Keys Do
    fData[Header].Clear;
  // Clear the list of headers as well
  fHeaders.Clear;
End;

/// <summary> Adds a new header to the collection.
/// </summary>
/// <param name="aHeader">The header name to add
/// </param>
/// <remarks>
/// If the header already exists, it is not added again.
/// </remarks>
Procedure TTabularData.AddHeader(Const aHeader: String);
Begin
  // Check if the header already exists in the dictionary
  If Not fData.ContainsKey(aHeader) Then
  Begin
    // If not, add the header to the dictionary and initialize an empty list for the column data
    fData.Add(aHeader, TList<String>.Create);
    // Add the header to the list of headers
    fHeaders.Add(aHeader);
  End;
End;

/// <summary> Sets data in the specified column and row.
/// </summary>
/// <param name="aHeader">The header name of the column
/// </param>
/// <param name="aData">The data to insert into the column
/// </param>
/// <remarks>
/// If the header does not exist, it is added automatically.
/// </remarks>
Procedure TTabularData.SetData(Const aHeader, aData: String);
Var
  Line: TList<String>;
Begin
  // Try to get the list of data for the specified header
  If Not fData.TryGetValue(aHeader, Line) Then
  Begin
    // If the header doesn't exist, add it and get the newly created list
    AddHeader(aHeader);
    Line := fData[aHeader];
  End;
  // Add the data to the list associated with the header
  Line.Add(aData);
End;

/// <summary> Formats the tabular data as a string for output.
/// </summary>
/// <remarks>
/// This method dynamically calculates column widths and formats the data into
/// a human-readable string. The output string will have columns aligned based
/// on the maximum width of the data in each column.
/// </remarks>
/// <returns>A string containing the formatted tabular data
/// </returns>
Function TTabularData.PrintData: String;
Var
  Output: TStringBuilder;
  Header: String;
  MaxWidths: TDictionary<String, Integer>;
  lX, lY, ColWidth: Integer;
  Line: TList<String>;
Begin
  // Create a string builder for efficient string concatenation
  Output := TStringBuilder.Create;
  // Create a dictionary to store the maximum width of each column
  MaxWidths := TDictionary<String, Integer>.Create;

  Try
    // Calculate the maximum column widths
    For Header In fHeaders Do
    Begin
      // Start with the length of the header as the minimum width
      ColWidth := Length(Header);
      Line := fData[Header];
      
      // Check each piece of data in the column and update the width if necessary
      For lY := 0 To Line.Count - 1 Do
        If Length(Line[lY]) > ColWidth Then
          ColWidth := Length(Line[lY]);
          
      // Store the maximum width for the current header
      MaxWidths.Add(Header, ColWidth);
    End;

    // Write the headers to the output string, aligned according to their maximum widths
    For Header In fHeaders Do
      Output.AppendFormat('|%s', [PadRight(Header, MaxWidths[Header])]);

    Output.AppendLine;

    // Write each row of data to the output string
    For lY := 0 To fData[fHeaders[0]].Count - 1 Do
    Begin
      // For each header, append the data aligned to the column width
      For Header In fHeaders Do
      Begin
        Line := fData[Header];
        Output.AppendFormat('|%s', [PadRight(Line[lY], MaxWidths[Header])]);
      End;
      Output.AppendLine;
    End;

    // Return the final formatted string
    Result := Output.ToString;
  Finally
    // Ensure memory is properly freed
    Output.Free;
    MaxWidths.Free;
  End;
End;

End.
