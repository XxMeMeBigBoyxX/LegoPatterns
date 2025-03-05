import std.mem;


struct Position
{
  float X; 
  float Y;
  float Width;
};
//The correlation might be flipped
struct IdCorrelation
{
  char16 Letter; 
  u16 ID;

};

struct Image
{
  u8 Img[$];
};

struct MainClass
{
  padding[8]; 
  u64 DDSPointer;
  padding[12];
  u32 CharacterAmmount;
  padding[4];  
  float GlobalHeight;
  float Rows; //UNKNOWN
  float Columns; //UNKNOWN
  padding[0x3c];  
  Position Pos1[CharacterAmmount-2];
  padding[0x14];  
  IdCorrelation Correlations[CharacterAmmount];
  Image MainImage @ DDSPointer+8;
};

MainClass file @ $;