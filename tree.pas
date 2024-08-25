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
/// This unit implements a Class representing a tree node with basic
/// functionalities for handling child nodes.
/// </summary>
Unit
	Tree;

Interface

Uses
	Classes,
	SysUtils,
	Contnrs,
	BaseException,
	StrUtils,
	NameValue;

Type
  /// <summary>
  /// Class representing a tree node with basic functionalities for handling child nodes.
  /// </summary>
	TTreeNode = Class(TObject)
	Private
		fOwner: TTreeNode;
		fChilds: TTreeNodeList;
		fCurrent: Integer;
		fReadOnly : Boolean;
		fCapable : TFPHashList;
		fFactory : TTreeClassFactory;
	Public
		{ Constructor And Destructor }
		/// <summary>
		/// Creates a new tree node with an optional owner.
		/// </summary>
		/// <param name="aOwner">The parent node that owns this node.</param>
		Constructor Create(Const aOwner : TTreeNode); Virtual;
		/// <summary>
		/// Destroys the tree node and cleans up resources.
		/// </summary>
		Destructor Destroy; Override;
		/// <summary>
		/// Performs any post-load operations on the node.
		/// </summary>
		Procedure AfterLoad; Virtual;
		{ Child manipulation }
		/// <summary>
		/// Appends a child node created from the specified class name.
		/// </summary>
		/// <param name="aClassName">The name of the class for the child node.</param>
		/// <returns>The newly created child node.</returns>
		Function AppendChild(Const aClassName : String): TTreeNode;
		/// <summary>
		/// Adds a specified child node to this node.
		/// </summary>
		/// <param name="aNode">The node to be added as a child.</param>
		/// <returns>The added child node.</returns>
		Function AddChild(Const aNode : TTreeNode): TTreeNode;
		/// <summary>
		/// Deletes a specified child node.
		/// </summary>
		/// <param name="aNode">The node to be deleted.</param>
		/// <remarks>
		/// Throws an exception if the node is read-only or not found.
		/// </remarks>
		Procedure Delete(Const aNode : TTreeNode);
		/// <summary>
		/// Removes all child nodes from this node.
		/// </summary>
		Procedure Purge;
		{ Child Navigation }
		/// <summary>
		/// Moves the current position to the first child node.
		/// </summary>
		Procedure First;
		/// <summary>
		/// Moves the current position to the next child node.
		/// </summary>
		Procedure Next;
		/// <summary>
		/// Moves the current position to the previous child node.
		/// </summary>
		Procedure Previous;
		/// <summary>
		/// Moves the current position to the last child node.
		/// </summary>
		Procedure Last;
		/// <summary>
		/// Checks if the current position is before the first child node.
		/// </summary>
		/// <returns>True if before the first node; otherwise, False.</returns>
		Function IsBeforeFirst: Boolean;
		/// <summary>
		/// Checks if the current position is at the first child node.
		/// </summary>
		/// <returns>True if at the first node; otherwise, False.</returns>
		Function IsAtFirst: Boolean;
		/// <summary>
		/// Checks if the current position is in the middle of child nodes.
		/// </summary>
		/// <returns>True if in the middle; otherwise, False.</returns>
		Function IsAtMiddle: Boolean;
		/// <summary>
		/// Checks if the current position is at the last child node.
		/// </summary>
		/// <returns>True if at the last node; otherwise, False.</returns>
		Function IsAtLast: Boolean;
		/// <summary>
		/// Checks if the current position is after the last child node.
		/// </summary>
		/// <returns>True if after the last node; otherwise, False.</returns>
		Function IsAfterLast: Boolean;
		/// <summary>
		/// Retrieves the first child node.
		/// </summary>
		/// <returns>The first child node.</returns>
		/// <remarks>
		/// Throws an exception if there are no child nodes.
		/// </remarks>
		Function GetFirst: TTreeNode;
		/// <summary>
		/// Retrieves the current child node.
		/// </summary>
		/// <returns>The current child node.</returns>
		/// <remarks>
		/// Throws an exception if the current position is out of bounds.
		/// </remarks>
		Function GetCurrent: TTreeNode;
		/// <summary>
		/// Retrieves the next child node.
		/// </summary>
		/// <returns>The next child node.</returns>
		/// <remarks>
		/// Throws an exception if the next position is out of bounds.
		/// </remarks>
		Function GetNext: TTreeNode;
		/// <summary>
		/// Retrieves the previous child node.
		/// </summary>
		/// <returns>The previous child node.</returns>
		/// <remarks>
		/// Throws an exception if the previous position is out of bounds.
		/// </remarks>
		Function GetPrevious: TTreeNode;
		/// <summary>
		/// Retrieves the last child node.
		/// </summary>
		/// <returns>The last child node.</returns>
		/// <remarks>
		/// Throws an exception if there are no child nodes.
		/// </remarks>
		Function GetLast: TTreeNode;
		/// <summary>
		/// Retrieves the current child node and moves to the next position.
		/// </summary>
		/// <returns>The current child node before moving to the next position.</returns>
		Function GetCurrentAndIncrement: TTreeNode;
		/// <summary>
		/// Retrieves the current child node and moves to the previous position.
		/// </summary>
		/// <returns>The current child node before moving to the previous position.</returns>
		Function GetCurrentAndDecrement: TTreeNode;
		/// <summary>
		/// Retrieves a child node by its index.
		/// </summary>
		/// <param name="aIndex">The index of the child node.</param>
		/// <returns>The child node at the specified index.</returns>
		/// <remarks>
		/// Throws an exception if the index is out of bounds.
		/// </remarks>
		Function GetChildByNumber(Const aIndex : Integer): TTreeNode;
		/// <summary>
		/// Retrieves the current index of this node within its parent's children.
		/// </summary>
		/// <returns>The current index of this node.</returns>
		Function GetCurrentIndex: Integer;
		/// <summary>
		/// Sets the current index of this node.
		/// </summary>
		/// <param name="aIndex">The index to be set.</param>
		Procedure SetCurrentIndex(Const aIndex : Integer);
		{ Tree utility }
		/// <summary>
		/// Retrieves the index of this node within its owner's children.
		/// </summary>
		/// <returns>The index of this node within its owner.</returns>
		Function GetMyIndex: Integer;
		/// <summary>
		/// Finds the root node of the tree to which this node belongs.
		/// </summary>
		/// <returns>The root node of the tree.</returns>
		Function FindRoot: TTreeNode;
		/// <summary>
		/// Finds the highest ancestor node of a specified class.
		/// </summary>
		/// <param name="aClass">The class to search for.</param>
		/// <returns>The highest ancestor node of the specified class.</returns>
		Function FindUppermost(Const aClass : TTreeNodeClass): TTreeNode;
		/// <summary>
		/// Finds the first descendant node of a specified class.
		/// </summary>
		/// <param name="aClass">The class to search for.</param>
		/// <returns>The first descendant node of the specified class.</returns>
		Function FindOfClass(Const aClass : TTreeNodeClass): TTreeNode;
		/// <summary>
		/// Finds the closest ancestor node of a specified class.
		/// </summary>
		/// <param name="aClass">The class to search for.</param>
		/// <returns>The closest ancestor node of the specified class.</returns>
		Function FindClosest(Const aClass : TTreeNodeClass): TTreeNode;
		/// <summary>
		/// Finds the closest ancestor node of a specified class name.
		/// </summary>
		/// <param name="aClassName">The name of the class to search for.</param>
		/// <returns>The closest ancestor node of the specified class name.</returns>
		Function FindClosestOfName(Const aClassName : String): TTreeNode;
		/// <summary>
		/// Retrieves a child node with a specified name.
		/// </summary>
		/// <param name="aName">The name of the child node.</param>
		/// <returns>The child node with the specified name.</returns>
		Function FindChildByName(Const aName: String): TTreeNode;
		/// <summary>
		/// Retrieves a child node with a specified name-value pair.
		/// </summary>
		/// <param name="aNameValue">The name-value pair to search for.</param>
		/// <returns>The child node with the specified name-value pair.</returns>
		Function FindChildByNameValue(Const aNameValue: TNameValue): TTreeNode;
		/// <summary>
		/// Retrieves a child node with a specified name and value.
		/// </summary>
		/// <param name="aName">The name of the child node.</param>
		/// <param name="aValue">The value of the child node.</param>
		/// <returns>The child node with the specified name and value.</returns>
		Function FindChildByNameValue(Const aName: String; Const aValue: String): TTreeNode;
		/// <summary>
		/// Determines if this node has any child nodes.
		/// </summary>
		/// <returns>True if there are child nodes; otherwise, False.</returns>
		Function HasChildren: Boolean;
		/// <summary>
		/// Retrieves the number of child nodes.
		/// </summary>
		/// <returns>The number of child nodes.</returns>
		Function CountChildren: Integer;
		/// <summary>
		/// Checks if this node is capable of handling a certain functionality.
		/// </summary>
		/// <param name="aCapability">The functionality to check for.</param>
		/// <returns>True if capable; otherwise, False.</returns>
		Function IsCapable(Const aCapability: String): Boolean;
		/// <summary>
		/// Sets the capability of this node.
		/// </summary>
		/// <param name="aCapability">The functionality to be set.</param>
		Procedure SetCapability(Const aCapability: String; Const aValue: Boolean);
		/// <summary>
		/// Checks if this node is read-only.
		/// </summary>
		/// <returns>True if read-only; otherwise, False.</returns>
		Function IsReadOnly: Boolean;
		/// <summary>
		/// Sets the read-only state of this node.
		/// </summary>
		/// <param name="aReadOnly">The read-only state to be set.</param>
		Procedure SetReadOnly(Const aReadOnly: Boolean);
		/// <summary>
		/// Retrieves the class factory for creating tree nodes.
		/// </summary>
		/// <returns>The tree class factory.</returns>
		Function GetFactory: TTreeClassFactory;
		/// <summary>
		/// Sets the class factory for creating tree nodes.
		/// </summary>
		/// <param name="aFactory">The class factory to be set.</param>
		Procedure SetFactory(Const aFactory: TTreeClassFactory);
		{ Properties }
		/// <summary>
		/// Retrieves the owner node of this node.
		/// </summary>
		/// <returns>The owner node.</returns>
		Property Owner: TTreeNode Read fOwner;
		/// <summary>
		/// Retrieves the list of child nodes.
		/// </summary>
		/// <returns>The list of child nodes.</returns>
		Property Childs: TTreeNodeList Read fChilds;
		/// <summary>
		/// Retrieves the current position within the child nodes.
		/// </summary>
		/// <returns>The current position index.</returns>
		Property Current: Integer Read fCurrent Write fCurrent;
		/// <summary>
		/// Checks if this node is read-only.
		/// </summary>
		/// <returns>True if read-only; otherwise, False.</returns>
		Property ReadOnly: Boolean Read fReadOnly Write fReadOnly;
		/// <summary>
		/// Retrieves the capabilities of this node.
		/// </summary>
		/// <returns>The capabilities of the node.</returns>
		Property Capable: TFPHashList Read fCapable Write fCapable;
		/// <summary>
		/// Retrieves the class factory for this node.
		/// </summary>
		/// <returns>The class factory.</returns>
		Property Factory: TTreeClassFactory Read fFactory Write fFactory;
	End;

Implementation

Function ReportRangeError(Const aCurrent : Integer; Const aNode : TTreeNode): String;
Begin
	If Length(aNode.Childs) > 0 Then
		Result := 'Access out of bounds (Max = ' + 
			IntToStr(High(aNode.Childs)) + ', Min = ' + 
			IntToStr(Low(aNode.Childs)) + ', Tried = ' + 
			IntToStr(aCurrent) + ').'
	Else
		Result := 'Access out of bounds (Node has no childs).';
End;

{ TTreeNode }

Constructor TTreeNode.Create(Const aOwner : TTreeNode);
Begin
	Inherited Create;
	fOwner := aOwner;
	If Assigned(fOwner) Then
		fOwner.AddChild(Self);
	SetLength(fChilds, 0);
	fCurrent := Low(fChilds);
	fReadOnly := False;
	fCapable := TFPHashList.Create;
	fFactory := TTreeClassFactory.Create;
End;

Destructor TTreeNode.Destroy;
Begin
	Purge;
	FreeAndNil(fFactory);
	FreeAndNil(fCapable);
	Inherited Destroy;
End;

Procedure TTreeNode.AfterLoad;
Begin
	First;
	While Not IsAfterLast Do
	Begin
		GetCurrent.AfterLoad;
		Next;
	End;
End;

Function TTreeNode.AppendChild(Const aClassName : String): TTreeNode;
Begin
	Result := fFactory.Build(aClassName, Self);
End;

Function TTreeNode.AddChild(Const aNode : TTreeNode): TTreeNode;
Begin
	SetLength(fChilds, Length(fChilds) + 1);
	fChilds[High(fChilds)] := aNode;
	Result := aNode;
End;

Procedure TTreeNode.Delete(Const aNode : TTreeNode);
Var
	lCtrl1,
	lCtrl2 : Integer;
	lFound : Boolean;
Begin
	If Length(fChilds) > 0 Then
	Begin
		lFound := False;
		For lCtrl1 := Low(fChilds) To High(fChilds) Do
			If fChilds[lCtrl1] = aNode Then
				If Not fChilds[lCtrl1].ReadOnly Then
				Begin
					lFound := True;
					FreeAndNil(fChilds[lCtrl1]);
					For lCtrl2 := lCtrl1 To High(fChilds) - 1 Do
						fChilds[lCtrl2] := fChilds[lCtrl2 + 1];
					SetLength(fChilds, Length(fChilds) - 1);
					Break;
				End
			Else
				Raise ETreeNode.Create('Node is read-only.');
		If Not(lFound) Then
			Raise ETreeNode.Create('Node not found.');
	End
	Else
		Raise ETreeNode.Create('Cannot delete from an empty set.');
End;

Procedure TTreeNode.Purge;
Var
	lCtrl : Integer;
Begin
	If Length(fChilds) > 0 Then
		For lCtrl := Low(fChilds) To High(fChilds) Do
			FreeAndNil(fChilds[lCtrl]);
	SetLength(fChilds, 0);
End;

Procedure TTreeNode.First;
Begin
	fCurrent := Low(fChilds);
End;

Procedure TTreeNode.Next;
Begin
	Inc(fCurrent);
End;

Procedure TTreeNode.Previous;
Begin
	Dec(fCurrent);
End;

Procedure TTreeNode.Last;
Begin
	fCurrent := High(fChilds);
End;

Function TTreeNode.IsBeforeFirst: Boolean;
Begin
	Result := fCurrent < Low(fChilds);
End;

Function TTreeNode.IsAtFirst: Boolean;
Begin
	Result := fCurrent = Low(fChilds);
End;

Function TTreeNode.IsAtMiddle: Boolean;
Begin
	Result := (fCurrent > Low(fChilds)) And (fCurrent < High(fChilds));
End;

Function TTreeNode.IsAtLast: Boolean;
Begin
	Result := fCurrent = High(fChilds);
End;

Function TTreeNode.IsAfterLast: Boolean;
Begin
	Result := fCurrent > High(fChilds);
End;

Function TTreeNode.GetFirst: TTreeNode;
Begin
	If Length(fChilds) > 0 Then
		Result := fChilds[Low(fChilds)]
	Else
	Begin
		Result := Nil;
		Raise ETreeNode.Create(ReportRangeError(0, Self));
	End;
End;

Function TTreeNode.GetCurrent: TTreeNode;
Begin
	If (fCurrent >= Low(fChilds)) And (fCurrent <= High(fChilds)) Then
		Result := fChilds[fCurrent]
	Else
		Raise ETreeNode.Create(ReportRangeError(fCurrent, Self));
End;

Function TTreeNode.GetNext: TTreeNode;
Begin
	If ((fCurrent + 1) >= Low(fChilds)) And ((fCurrent + 1) <= High(fChilds)) Then
		Result := fChilds[fCurrent + 1]
	Else
	Begin
		Result := Nil;
		Raise ETreeNode.Create(ReportRangeError(fCurrent + 1, Self));
	End;
End;

Function TTreeNode.GetPrevious: TTreeNode;
Begin
	If ((fCurrent - 1) >= Low(fChilds)) And ((fCurrent - 1) <= High(fChilds)) Then
		Result := fChilds[fCurrent - 1]
	Else
	Begin
		Result := Nil;
		Raise ETreeNode.Create(ReportRangeError(fCurrent - 1, Self));
	End;
End;

Function TTreeNode.GetLast: TTreeNode;
Begin
	If Length(fChilds) > 0 Then
		Result := fChilds[High(fChilds)]
	Else
	Begin
		Result := Nil;
		Raise ETreeNode.Create(ReportRangeError(0, Self));
	End;
End;

Function TTreeNode.GetCurrentAndIncrement: TTreeNode;
Begin
	Result := GetCurrent;
	Next;
End;

Function TTreeNode.GetCurrentAndDecrement: TTreeNode;
Begin
	Result := GetCurrent;
	Previous;
End;

Function TTreeNode.GetChildByNumber(Const aIndex : Integer): TTreeNode;
Begin
	If (aIndex >= Low(fChilds)) And (aIndex <= High(fChilds)) Then
		Result := fChilds[aIndex]
	Else
		Raise ETreeNode.Create(ReportRangeError(aIndex, Self));
End;

Function TTreeNode.GetCurrentIndex : Integer;
Begin
	Result := fCurrent;
End;

Procedure TTreeNode.SetCurrentIndex(Const aIndex : Integer);
Begin
	fCurrent := aIndex;
End;

Function TTreeNode.GetMyIndex: Integer;
Var
	lSavedIndex : Integer;
Begin
	Result := 0;
	If Assigned(fOwner) Then
	Begin
		lSavedIndex := fOwner.GetCurrentIndex;
		fOwner.First;
		While Not fOwner.IsAfterLast Do
		Begin
			If fOwner.GetCurrent = Self Then
				Result := fOwner.GetCurrentIndex;
			fOwner.Next;
		End;
		fOwner.SetCurrentIndex(lSavedIndex);
	End;
End;

Function TTreeNode.FindRoot: TTreeNode;
Begin
	If Assigned(fOwner) Then
		Result := fOwner.FindRoot
	Else
		Result := Self;
End;

Function TTreeNode.FindUppermost(Const aClass : TTreeNodeClass): TTreeNode;
Begin
	If Assigned(fOwner) And (fOwner Is aClass) Then
		Result := fOwner.FindUppermost(aClass)
	Else
		Result := Self;
End;

Function TTreeNode.FindOfClass(Const aClass : TTreeNodeClass): TTreeNode;
Var
	lCtrl : Integer;
Begin
	Result := Nil;
	For lCtrl := Low(fChilds) To High(fChilds) Do
		If fChilds[lCtrl] Is aClass Then
		Begin
			Result := fChilds[lCtrl];
			Break;
		End;
End;

Function TTreeNode.FindUpwards(Const aClass : TTreeNodeClass): TTreeNode;
Begin
	If Self Is aClass Then
		Result := Self
	Else
		If Assigned(fOwner) Then
			Result := fOwner.FindUpwards(aClass)
		Else
			Result := Nil;
End;

Function TTreeNode.GroupBy(Const aClass : TTreeNodeClass): TTreeNodeList;
Var
	lCtrl : Integer;
Begin
	SetLength(Result, 0);
	For lCtrl := Low(fChilds) To High(fChilds) Do
		If fChilds[lCtrl] Is aClass Then
		Begin
			SetLength(Result, Length(Result) + 1);
			Result[High(Result)] := fChilds[lCtrl];
		End;
End;

Procedure TTreeNode.SetAsCapable(Const aCommandName : String);
Begin
	fCapable.Add(aCommandName, Pointer(Self));
End;

Function TTreeNode.IsCapable(Const aCommandName : String): Boolean;
Begin
	Result := fCapable.FindIndexOf(aCommandName) >= 0;
End;

{ TTreeNodeWithName }

Function TTreeNodeWithName.NumericalName: String;
Begin
	If Assigned(Owner) And (Owner Is TTreeNodeWithName) Then
		Result := (Owner As TTreeNodeWithName).NumericalName + '.[' + IntToStr(GetMyIndex) + ']'
	Else
		Result := '$ROOT$';
End;

Function TTreeNodeWithName.IndexedName : String;
Begin
	If Assigned(Owner) And (Owner Is TTreeNodeWithName) Then
		If Assigned(Owner.Owner) And (Owner.Owner Is TTreeNodeWithName) Then
			Result := (Owner As TTreeNodeWithName).IndexedName + '.' + fName
		Else
			Result := fName;
End;

Function TTreeNodeWithName.Find(Const aName : String): TTreeNodeWithName;
Var
	lCtrl : Integer;
Begin
	Result := Nil;
	For lCtrl := Low(Childs) To High(Childs) Do
		If LowerCase((Childs[lCtrl] As TTreeNodeWithName).Name) = LowerCase(aName) Then
		Begin
			Result := Childs[lCtrl] As TTreeNodeWithName;
			Break;
		End;
	If Result = Nil Then
		Raise ETreeNode.Create('Theres no child named ' + aName + ' in the node ' + IndexedName);
End;

Function TTreeNodeWithName.HasChildNamed(Const aName : String): Boolean;
Var
	lCtrl : Integer;
Begin
	Result := False;
	For lCtrl := Low(Childs) To High(Childs) Do
		If (Childs[lCtrl] As TTreeNodeWithName).Name = aName Then
		Begin
			Result := True;
			Break;
		End;
End;

{ TTreeNodeWithProperties }

Constructor TTreeNodeWithProperties.Create(Const aOwner : TTreeNode);
Begin
	Inherited Create(aOwner);
	fProperties := TNameValue.Create;
End;

Destructor TTreeNodeWithProperties.Destroy;
Begin
	FreeAndNil(fProperties);
	Inherited Destroy;
End;

{ TTreeNodeIterator }

Procedure TTreeNodeIterator.Visit(Const aTarget : TTreeNode);
Var
	lCtrl : Integer;
Begin
	Process(aTarget);
	If Length(aTarget.Childs) > 1 Then
	Begin
		OnBeforeAllChilds(aTarget);
		For lCtrl := Low(aTarget.Childs) To High(aTarget.Childs) Do
		Begin
			OnBeforeChild(aTarget);
			Visit(aTarget.Childs[lCtrl]);
			OnAfterChild(aTarget);
		End;
		OnAfterAllChilds(aTarget);
	End
	Else If Length(aTarget.Childs) = 1 Then
	Begin
		OnBeforeSingleChild(aTarget);
		Visit(aTarget.GetFirst);
		OnAfterSingleChild(aTarget);
	End
	Else If Length(aTarget.Childs) < 1 Then
		OnNoChild(aTarget);
End;

Procedure TTreeNodeIterator.OnNoChild(Const aTarget : TTreeNode);
Begin
End;

Procedure TTreeNodeIterator.OnBeforeSingleChild(Const aTarget : TTreeNode);
Begin
End;

Procedure TTreeNodeIterator.OnAfterSingleChild(Const aTarget : TTreeNode);
Begin
End;

Procedure TTreeNodeIterator.OnBeforeAllChilds(Const aTarget : TTreeNode);
Begin
End;

Procedure TTreeNodeIterator.OnAfterAllChilds(Const aTarget : TTreeNode);
Begin
End;

Procedure TTreeNodeIterator.OnBeforeChild(Const aTarget : TTreeNode);
Begin
End;

Procedure TTreeNodeIterator.OnAfterChild(Const aTarget : TTreeNode);
Begin
End;

{ TTreeClassFactory }

Constructor TTreeClassFactory.Create;
Begin
	Inherited Create;
	fHash := TFPHashList.Create;
End;

Destructor TTreeClassFactory.Destroy; 
Begin
	FreeAndNil(fHash);
	Inherited Destroy;
End;

Procedure TTreeClassFactory.Register(Const aClassName : String; Const aClassInfo : TTreeNodeClass);
Begin
	fHash.Add(aClassName, Pointer(aClassInfo));
End;

Function TTreeClassFactory.Build(Const aClassName : String; Const aOwner : TTreeNode): TTreeNode;
Var
	lIndex : Integer;
	lClass : TTreeNodeClass;
Begin
	lIndex := fHash.FindIndexOf(aClassName);
	If lIndex >= 0 Then
		lClass := TTreeNodeClass(fHash.Items[lIndex])
	Else
		lClass := fDefaultClass;
	Result := lClass.Create(aOwner);
End;

Function TTreeClassFactory.IsRegisteredClass(Const aClassName : String): Boolean;
Begin
	Result := fHash.FindIndexOf(aClassName) >= 0;
End;

End.
