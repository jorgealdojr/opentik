unit NameValue;

interface

uses
  Classes, SysUtils, Variants, Generics.Collections;

type
  /// <summary>
  /// Exception class for errors related to TNameValue operations.
  /// </summary>
  ENameValue = class(Exception);

  /// <summary>
  /// Represents a name-value pair.
  /// </summary>
  TNameValuePair = class(TObject)
  private
    fName: String; ///< Name of the pair
    fValue: Variant; ///< Value of the pair
  public
    /// <summary>
    /// Creates a TNameValuePair with the specified name and value.
    /// </summary>
    /// <param name="aName">The name of the pair.</param>
    /// <param name="aValue">The value of the pair.</param>
    constructor Create(const aName: String; const aValue: Variant);
    /// <summary>
    /// Returns a formatted string representation of the pair.
    /// </summary>
    /// <returns>A string in the format 'Name="Value".</returns>
    function Formatted: String;
    /// <summary>
    /// Gets or sets the name of the pair.
    /// </summary>
    property Name: String read fName write fName;
    /// <summary>
    /// Gets or sets the value of the pair.
    /// </summary>
    property Value: Variant read fValue write fValue;
  end;

  /// <summary>
  /// Represents a collection of name-value pairs.
  /// </summary>
  TNameValue = class(TObject)
  private
    fPairs: TList<TNameValuePair>; ///< List of name-value pairs
    fNameIndex: TDictionary<String, TList<TListNode<TNameValuePair>>>; ///< Index for quick lookup by name
    /// <summary>
    /// Gets the value of the pair at the specified index.
    /// </summary>
    /// <param name="aIndex">The index of the pair.</param>
    /// <returns>The value of the pair at the specified index.</returns>
    function GetByIndex(const aIndex: Integer): Variant;
    /// <summary>
    /// Sets the value of the pair at the specified index.
    /// </summary>
    /// <param name="aIndex">The index of the pair.</param>
    /// <param name="aValue">The value to set.</param>
    procedure SetByIndex(const aIndex: Integer; const aValue: Variant);
    /// <summary>
    /// Gets the value of the pair with the specified name.
    /// </summary>
    /// <param name="aName">The name of the pair.</param>
    /// <returns>The value of the pair with the specified name.</returns>
    function GetByName(const aName: String): Variant;
    /// <summary>
    /// Sets the value of the pair with the specified name.
    /// </summary>
    /// <param name="aName">The name of the pair.</param>
    /// <param name="aValue">The value to set.</param>
    procedure SetByName(const aName: String; const aValue: Variant);
  public
    /// <summary>
    /// Creates a new TNameValue instance.
    /// </summary>
    constructor Create;
    /// <summary>
    /// Destroys the TNameValue instance and frees all resources.
    /// </summary>
    destructor Destroy; override;
    /// <summary>
    /// Adds a name-value pair to the collection.
    /// </summary>
    /// <param name="aPair">The TNameValuePair to add.</param>
    /// <returns>The added TNameValuePair.</returns>
    function Add(const aPair: TNameValuePair): TNameValuePair;
    /// <summary>
    /// Deletes a name-value pair from the collection.
    /// </summary>
    /// <param name="aPair">The TNameValuePair to delete.</param>
    procedure Delete(const aPair: TNameValuePair);
    /// <summary>
    /// Removes all name-value pairs from the collection.
    /// </summary>
    procedure Purge;
    /// <summary>
    /// Finds a name-value pair by name.
    /// </summary>
    /// <param name="aName">The name of the pair to find.</param>
    /// <returns>The TNameValuePair with the specified name, or nil if not found.</returns>
    function Find(const aName: String): TNameValuePair;
    /// <summary>
    /// Checks if a name-value pair with the specified name exists in the collection.
    /// </summary>
    /// <param name="aName">The name to check.</param>
    /// <returns>True if the pair exists; otherwise, False.</returns>
    function Exists(const aName: String): Boolean;
    /// <summary>
    /// Merges another TNameValue instance into the current instance.
    /// </summary>
    /// <param name="aNameValue">The TNameValue instance to merge.</param>
    procedure Merge(const aNameValue: TNameValue);
    /// <summary>
    /// Checks if the value for a specific name matches the given value.
    /// </summary>
    /// <param name="aName">The name of the pair.</param>
    /// <param name="aValue">The value to match.</param>
    /// <returns>True if the value matches; otherwise, False.</returns>
    function Match(const aName: String; const aValue: Variant): Boolean;
    /// <summary>
    /// Gets or sets the value of the pair at the specified index.
    /// </summary>
    property ByIndex[const aIndex: Integer]: Variant read GetByIndex write SetByIndex; 
    /// <summary>
    /// Gets or sets the value of the pair with the specified name.
    /// This is the default property and can be accessed using Indexers.
    /// </summary>
    property ByName[const aName: String]: Variant read GetByName write SetByName; default;
  end;

/// <summary>
/// Compares a TNameValue instance against another two instances for equality.
/// </summary>
/// <param name="aData">The data to compare.</param>
/// <param name="aEquals">The TNameValue instance that should be equal to aData.</param>
/// <param name="aNotEquals">The TNameValue instance that should not be equal to aData.</param>
/// <returns>True if the comparison matches the criteria; otherwise, False.</returns>
function CompareNameValue(const aData, aEquals, aNotEquals: TNameValue): Boolean;

/// <summary>
/// Compares a TNameValue instance for equality with another instance.
/// </summary>
/// <param name="aData">The data to compare.</param>
/// <param name="aEquals">The TNameValue instance that should be equal to aData.</param>
/// <returns>True if the instances are equal; otherwise, False.</returns>
function CompareEqual(const aData, aEquals: TNameValue): Boolean;

/// <summary>
/// Compares a TNameValue instance to ensure it is not equal to another instance.
/// </summary>
/// <param name="aData">The data to compare.</param>
/// <param name="aNotEquals">The TNameValue instance that should not be equal to aData.</param>
/// <returns>True if the instances are not equal; otherwise, False.</returns>
function CompareNotEqual(const aData, aNotEquals: TNameValue): Boolean;

implementation

{ TNameValuePair }

constructor TNameValuePair.Create(const aName: String; const aValue: Variant);
begin
  inherited Create;
  fName := aName;
  fValue := aValue;
end;

function TNameValuePair.Formatted: String;
begin
  Result := fName + '="' + VarToStr(fValue) + '"';
end;

{ TNameValue }

constructor TNameValue.Create;
begin
  inherited Create;
  fPairs := TList<TNameValuePair>.Create;
  fNameIndex := TDictionary<String, TList<TListNode<TNameValuePair>>>.Create;
end;

destructor TNameValue.Destroy;
begin
  Purge;
  fPairs.Free;
  fNameIndex.Free;
  inherited Destroy;
end;

function TNameValue.Add(const aPair: TNameValuePair): TNameValuePair;
var
  Nodes: TList<TListNode<TNameValuePair>>;
  Node: TListNode<TNameValuePair>;
begin
  Result := aPair;
  fPairs.Add(aPair);
  if not fNameIndex.TryGetValue(aPair.Name, Nodes) then
  begin
    Nodes := TList<TListNode<TNameValuePair>>.Create;
    fNameIndex.Add(aPair.Name, Nodes);
  end;
  Node := TListNode<TNameValuePair>.Create(aPair);
  Nodes.Add(Node);
end;

procedure TNameValue.Delete(const aPair: TNameValuePair);
var
  Nodes: TList<TListNode<TNameValuePair>>;
  Node: TListNode<TNameValuePair>;
  Index: Integer;
begin
  if fNameIndex.TryGetValue(aPair.Name, Nodes) then
  begin
    for Index := 0 to Nodes.Count - 1 do
    begin
      Node := Nodes[Index];
      if Node.Value = aPair then
      begin
        Nodes.Delete(Index);
        FreeAndNil(Node);
        Break;
      end;
    end;
    if Nodes.Count = 0 then
    begin
      fNameIndex.Remove(aPair.Name);
      Nodes.Free;
    end;
  end;
  fPairs.Remove(aPair);
  FreeAndNil(aPair);
end;

procedure TNameValue.Purge;
var
  Pair: TNameValuePair;
begin
  for Pair in fPairs do
    FreeAndNil(Pair);
  fPairs.Clear;
  fNameIndex.Clear;
end;

function TNameValue.Find(const aName: String): TNameValuePair;
var
  Nodes: TList<TListNode<TNameValuePair>>;
  Node: TListNode<TNameValuePair>;
begin
  Result := nil;
  if fNameIndex.TryGetValue(aName, Nodes) then
  begin
    if Nodes.Count > 0 then
    begin
      Node := Nodes.First;
      Result := Node.Value;
    end;
  end;
end;

function TNameValue.Exists(const aName: String): Boolean;
begin
  Result := Find(aName) <> nil;
end;

function TNameValue.GetByIndex(const aIndex: Integer): Variant;
begin
  if (aIndex >= 0) and (aIndex < fPairs.Count) then
    Result := fPairs[aIndex].Value
  else
    raise ENameValue.Create('Index out of bounds.');
end;

procedure TNameValue.SetByIndex(const aIndex: Integer; const aValue: Variant);
begin
  if (aIndex >= 0) and (aIndex < fPairs.Count) then
    fPairs[aIndex].Value := aValue
  else
    raise ENameValue.Create('Index out of bounds.');
end;

function TNameValue.GetByName(const aName: String): Variant;
var
  Pair: TNameValuePair;
begin
  Pair := Find(aName);
  if Assigned(Pair) then
    Result := Pair.Value
  else
    raise ENameValue.Create('Name not found.');
end;

procedure TNameValue.SetByName(const aName: String; const aValue: Variant);
var
  Pair: TNameValuePair;
begin
  Pair := Find(aName);
  if Assigned(Pair) then
    Pair.Value := aValue
  else
    Add(TNameValuePair.Create(aName, aValue));
end;

function TNameValue.Match(const aName: String; const aValue: Variant): Boolean;
begin
  Result := Exists(aName) and (GetByName(aName) = aValue);
end;

function CompareNameValue(const aData, aEquals, aNotEquals: TNameValue): Boolean;
begin
  if Assigned(aEquals) then
    if Assigned(aNotEquals) then
      Result := CompareEqual(aData, aEquals) and CompareNotEqual(aData, aNotEquals)
    else
      Result := CompareEqual(aData, aEquals)
  else
    if Assigned(aNotEquals) then
      Result := CompareNotEqual(aData, aNotEquals)
    else
      Result := False;
end;

function CompareEqual(const aData, aEquals: TNameValue): Boolean;
var
  Pair: TNameValuePair;
begin
  Result := True;
  for Pair in aEquals.fPairs do
    Result := Result and aData.Match(Pair.Name, Pair.Value);
end;

function CompareNotEqual(const aData, aNotEquals: TNameValue): Boolean;
var
  Pair: TNameValuePair;
begin
  Result := True;
  for Pair in aNotEquals.fPairs do
    Result := Result and not aData.Match(Pair.Name, Pair.Value);
end;

end.
