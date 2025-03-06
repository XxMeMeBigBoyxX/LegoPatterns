// AN3.hexpat - ImHex Pattern for AN3 Animation Files

struct SkeletonMatrixEntry {
    u16 TranslateX  [[color("FF0000")]];
    u16 TranslateY  [[color("FF3030")]];
    u16 TranslateZ  [[color("FF6060")]];
    u16 RotateX     [[color("00FF00")]];
    u16 RotateY     [[color("00cF00")]];
    u16 RotateZ     [[color("00aF00")]];
    u16 ScaleX      [[color("0000FF")]];
    u16 ScaleY      [[color("4040FF")]];
    u16 ScaleZ      [[color("8080FF")]];  
};

struct MovingParameters {
    float Scale   [[color("002FFF")]];
    float Minimum  [[color("006FFF")]];
};

bitfield KeyframeNode{
    u8 Position [[color("00FF00")]];
    section_0: 6 [[color("001FFF")]];
    section_1: 6 [[color("004FFF")]];
    section_2: 6 [[color("007FFF")]];
    section_3: 6 [[color("00AFFF")]];
};

struct Keyframe<auto NumNodes>{
    KeyframeNode nodes[NumNodes];
};

bitfield CurvesetFlag{
    ApplyRotation: 1;
    ApplyTranslation : 1;
    padding : 1;
    ApplyScale : 1;
    ApplyInvScale : 1;
    InheritParentRotation : 1; //Maybe, this is kinda confusing. Matrix math
    BaseJoint_SetScaleToOne : 1;
    padding : 1;
};

struct MainClass {
    char version[4];         // File version (e.g., "4INA", "6INA", "8INA")
    u16 NumNodes;            // Number of nodes (bones)
    u16 NumFrames;           // Number of animation frames
    u16 CurveGroupSize;      // Curve group size
    u16 OriginalNumFrames;   // Original number of frames
    u16 NumCurves;           // Number of curves
    u16 FirstFrame;          // First frame index
    u8 EndFrames;            // End frame index
    u8 NumShortIntegers;     // Number of short integers
    u8 FixedUp;              // Fixed up flag
    u8 Unused1;              // Unused value
    u32 Unused2;             // Another unused value
    u32 FrameIndexList_ptr;  // Pointer to frame index list
    float ConstantBase;      // Constant base value
    float ConstantScale;     // Constant scale value
    u32 CurveScalesMins_ptr; // Pointer to curve scale mins
    u32 Constants_ptr;       // Pointer to constants section
    u32 KeyTypes_ptr;        // Pointer to key types
    u32 Keys_ptr;            // Pointer to animation key data
    u32 curvesetflags_ptr;   // Pointer to curve set flags
    u32 TangentKeys_ptr;     // Pointer to tangent key data
    
    auto MovingNodes = CurveGroupSize/4;
    auto NumKframes = (curvesetflags_ptr-Keys_ptr)/CurveGroupSize;
    
    if (version == "4INA"){
        char metaData[];
    } else if (version == "6INA"){
        padding[0x14];
        char metaData[];
    } else if (version == "8INA"){
        u32 FileInfo_ptr;         // Pointer to File Info
        padding[0x10];
        char metaData[];
    }
    
    //Pad until constants
    padding[(Constants_ptr-$)];
    
    // Constants (Static Values)
    u16 Constants[((KeyTypes_ptr-Constants_ptr)/2)];
    
    // Skeleton Matrix (Key Types)    
    SkeletonMatrixEntry keyTypes[NumNodes];
    
    
    //Pad until Movement Parameters
    padding[(CurveScalesMins_ptr-$)];
    
    //Movement Parameters (Scaling and Minimum Values)
    MovingParameters CurveScalesMins[MovingNodes];
    
    //Keyframes (Moving Data)
    Keyframe<MovingNodes> Keys[NumKframes];
    
    
    //Pad until Flags
    padding[(curvesetflags_ptr-$)];
    
    //Flags (Tells the engine how to apply this data)
    CurvesetFlag Flags[NumNodes];
    
    // Extra Information (Only for 8INA version)
    if (version == "8INA") {
        //Pad to EndData_ptr
        padding[(FileInfo_ptr-$)];
    
        u32 unknownNumber;
        u32 EndOfFile_ptr;
    }
    
};
MainClass file @ $;