#############################################################################
##
#W  PackageInfo.g    GAP 4 package 'Satisfiability'    Mathieu Dutour Sikiric
##
##

SetPackageInfo( rec(

PackageName := "Satisfiability",
Subtitle := "Interface to MINISAT for resolving satisfiability problems",
Version := "1.0",
Date := "29/10/2020", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [

 rec(
      LastName      := "Dutour Sikiri\'c",
      FirstNames    := "Mathieu",
      IsAuthor      := true,
      IsMaintainer  := true,
      Email         := "mathieu.dutour@gmail.com",
      WWWHome       := "http://mathieudutour.altervista.org/",
      PostalAddress := Concatenation( [
            "Institut Rudjer Boskovic",
            "Bijenicka Cesta 54\n",
            "10000 Zagreb, Croatia" ] ),
      Place         := "Zagreb",
      Institution   := "Institut Rudjer Boskovic"),

],

Status := "accepted",
CommunicatedBy := "David Joyner (Annapolis)",
AcceptDate := "10/2007",

PackageWWWHome  := "https://github.com/MathieuDutSik/Satisfiability",
README_URL      := Concatenation( ~.PackageWWWHome, "README.md" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/MathieuDutSik/Satisfiability",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/cubefree-", ~.Version ),
ArchiveFormats := ".tar.gz",

AbstractHTML :=
"The <span class=\"pkgname\">Satisfiability</span> package provides ways to solve satisfiability questions by using minisat", 

PackageDoc := rec(
  BookName  := "Satisfiability",
  ArchiveURLSubset := ["doc", "htm"],
  HTMLStart := "htm/chapters.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Constructing the groups of a given cubefree order",
  Autoload  := true),

Dependencies := rec(
  GAP := ">=4.8",
  NeededOtherPackages := [["GRAPE", ">= 4.8"]],
  SuggestedOtherPackages := [],
  ExternalConditions := [] ),

AvailabilityTest := ReturnTrue,
Autoload := false,
TestFile := "tst/testall.g",
Keywords := ["Satisfiability","chromatic number", "tilings"]

));
