.class public Lorg/cocos2dx/lib/Cocos2dxBitmap;
.super Ljava/lang/Object;
.source "Cocos2dxBitmap.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;
    }
.end annotation


# static fields
.field private static final HORIZONTALALIGN_CENTER:I = 0x3

.field private static final HORIZONTALALIGN_LEFT:I = 0x1

.field private static final HORIZONTALALIGN_RIGHT:I = 0x2

.field private static final VERTICALALIGN_BOTTOM:I = 0x2

.field private static final VERTICALALIGN_CENTER:I = 0x3

.field private static final VERTICALALIGN_TOP:I = 0x1

.field private static sContext:Landroid/content/Context;


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 44
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static computeTextProperty(Ljava/lang/String;IILandroid/graphics/Paint;)Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;
    .locals 11
    .param p0, "string"    # Ljava/lang/String;
    .param p1, "width"    # I
    .param p2, "height"    # I
    .param p3, "paint"    # Landroid/graphics/Paint;

    .prologue
    const/4 v7, 0x0

    .line 240
    invoke-virtual {p3}, Landroid/graphics/Paint;->getFontMetricsInt()Landroid/graphics/Paint$FontMetricsInt;

    move-result-object v0

    .line 241
    .local v0, "fm":Landroid/graphics/Paint$FontMetricsInt;
    iget v6, v0, Landroid/graphics/Paint$FontMetricsInt;->bottom:I

    iget v8, v0, Landroid/graphics/Paint$FontMetricsInt;->top:I

    sub-int/2addr v6, v8

    int-to-double v8, v6

    invoke-static {v8, v9}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v8

    double-to-int v1, v8

    .line 242
    .local v1, "h":I
    const/4 v4, 0x0

    .line 244
    .local v4, "maxContentWidth":I
    invoke-static {p0, p1, p2, p3}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->splitString(Ljava/lang/String;IILandroid/graphics/Paint;)[Ljava/lang/String;

    move-result-object v3

    .line 247
    .local v3, "lines":[Ljava/lang/String;
    if-eqz p1, :cond_1

    .line 248
    move v4, p1

    .line 261
    :cond_0
    new-instance v6, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;

    invoke-direct {v6, v4, v1, v3}, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;-><init>(II[Ljava/lang/String;)V

    return-object v6

    .line 251
    :cond_1
    const/4 v5, 0x0

    .line 252
    .local v5, "temp":I
    array-length v8, v3

    move v6, v7

    :goto_0
    if-ge v6, v8, :cond_0

    aget-object v2, v3, v6

    .line 254
    .local v2, "line":Ljava/lang/String;
    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v9

    .line 253
    invoke-virtual {p3, v2, v7, v9}, Landroid/graphics/Paint;->measureText(Ljava/lang/String;II)F

    move-result v9

    float-to-double v9, v9

    invoke-static {v9, v10}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v9

    double-to-int v5, v9

    .line 255
    if-le v5, v4, :cond_2

    .line 256
    move v4, v5

    .line 252
    :cond_2
    add-int/lit8 v6, v6, 0x1

    goto :goto_0
.end method

.method private static computeX(Ljava/lang/String;II)I
    .locals 1
    .param p0, "text"    # Ljava/lang/String;
    .param p1, "maxWidth"    # I
    .param p2, "horizontalAlignment"    # I

    .prologue
    .line 266
    const/4 v0, 0x0

    .line 268
    .local v0, "ret":I
    packed-switch p2, :pswitch_data_0

    .line 280
    :goto_0
    return v0

    .line 270
    :pswitch_0
    div-int/lit8 v0, p1, 0x2

    .line 271
    goto :goto_0

    .line 273
    :pswitch_1
    move v0, p1

    .line 274
    goto :goto_0

    .line 268
    :pswitch_data_0
    .packed-switch 0x2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private static computeY(Landroid/graphics/Paint$FontMetricsInt;III)I
    .locals 3
    .param p0, "fontMetricsInt"    # Landroid/graphics/Paint$FontMetricsInt;
    .param p1, "constrainHeight"    # I
    .param p2, "totalHeight"    # I
    .param p3, "verticalAlignment"    # I

    .prologue
    .line 286
    iget v1, p0, Landroid/graphics/Paint$FontMetricsInt;->top:I

    neg-int v0, v1

    .line 288
    .local v0, "y":I
    if-le p1, p2, :cond_0

    .line 289
    packed-switch p3, :pswitch_data_0

    .line 305
    :cond_0
    :goto_0
    return v0

    .line 291
    :pswitch_0
    iget v1, p0, Landroid/graphics/Paint$FontMetricsInt;->top:I

    neg-int v0, v1

    .line 292
    goto :goto_0

    .line 294
    :pswitch_1
    iget v1, p0, Landroid/graphics/Paint$FontMetricsInt;->top:I

    neg-int v1, v1

    sub-int v2, p1, p2

    .line 295
    div-int/lit8 v2, v2, 0x2

    .line 294
    add-int v0, v1, v2

    .line 296
    goto :goto_0

    .line 298
    :pswitch_2
    iget v1, p0, Landroid/graphics/Paint$FontMetricsInt;->top:I

    neg-int v1, v1

    sub-int v2, p1, p2

    add-int v0, v1, v2

    .line 299
    goto :goto_0

    .line 289
    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_2
        :pswitch_1
    .end packed-switch
.end method

.method public static createTextBitmap(Ljava/lang/String;Ljava/lang/String;IIII)V
    .locals 19
    .param p0, "string"    # Ljava/lang/String;
    .param p1, "fontName"    # Ljava/lang/String;
    .param p2, "fontSize"    # I
    .param p3, "alignment"    # I
    .param p4, "width"    # I
    .param p5, "height"    # I

    .prologue
    .line 96
    const/high16 v3, 0x3f800000    # 1.0f

    const/high16 v4, 0x3f800000    # 1.0f

    const/high16 v5, 0x3f800000    # 1.0f

    .line 98
    const/4 v9, 0x0

    const/4 v10, 0x0

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    .line 99
    const/4 v14, 0x0

    const/high16 v15, 0x3f800000    # 1.0f

    const/high16 v16, 0x3f800000    # 1.0f

    const/high16 v17, 0x3f800000    # 1.0f

    const/high16 v18, 0x3f800000    # 1.0f

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move/from16 v2, p2

    move/from16 v6, p3

    move/from16 v7, p4

    move/from16 v8, p5

    .line 96
    invoke-static/range {v0 .. v18}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->createTextBitmapShadowStroke(Ljava/lang/String;Ljava/lang/String;IFFFIIIZFFFFZFFFF)Z

    .line 101
    return-void
.end method

.method public static createTextBitmapShadowStroke(Ljava/lang/String;Ljava/lang/String;IFFFIIIZFFFFZFFFF)Z
    .locals 31
    .param p0, "string"    # Ljava/lang/String;
    .param p1, "fontName"    # Ljava/lang/String;
    .param p2, "fontSize"    # I
    .param p3, "fontTintR"    # F
    .param p4, "fontTintG"    # F
    .param p5, "fontTintB"    # F
    .param p6, "alignment"    # I
    .param p7, "width"    # I
    .param p8, "height"    # I
    .param p9, "shadow"    # Z
    .param p10, "shadowDX"    # F
    .param p11, "shadowDY"    # F
    .param p12, "shadowBlur"    # F
    .param p13, "shadowOpacity"    # F
    .param p14, "stroke"    # Z
    .param p15, "strokeR"    # F
    .param p16, "strokeG"    # F
    .param p17, "strokeB"    # F
    .param p18, "strokeSize"    # F

    .prologue
    .line 110
    and-int/lit8 v12, p6, 0xf

    .line 111
    .local v12, "horizontalAlignment":I
    shr-int/lit8 v24, p6, 0x4

    and-int/lit8 v21, v24, 0xf

    .line 113
    .local v21, "verticalAlignment":I
    invoke-static/range {p0 .. p0}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->refactorString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 114
    move-object/from16 v0, p1

    move/from16 v1, p2

    invoke-static {v0, v1, v12}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->newPaint(Ljava/lang/String;II)Landroid/graphics/Paint;

    move-result-object v16

    .line 117
    .local v16, "paint":Landroid/graphics/Paint;
    if-eqz p7, :cond_0

    .line 119
    const/16 v24, 0x0

    const/16 v25, 0x1

    move-object/from16 v0, v16

    move-object/from16 v1, p0

    move/from16 v2, v24

    move/from16 v3, v25

    invoke-virtual {v0, v1, v2, v3}, Landroid/graphics/Paint;->measureText(Ljava/lang/String;II)F

    move-result v24

    move/from16 v0, v24

    float-to-double v0, v0

    move-wide/from16 v24, v0

    invoke-static/range {v24 .. v25}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v24

    move-wide/from16 v0, v24

    double-to-int v10, v0

    .line 120
    .local v10, "firstWordWidth":I
    move/from16 v0, p7

    if-le v10, v0, :cond_0

    .line 122
    const-string v24, "createTextBitmapShadowStroke warning:"

    const-string v25, "the input width is less than the width of the pString\'s first word\n"

    invoke-static/range {v24 .. v25}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 123
    const/16 v24, 0x0

    .line 195
    .end local v10    # "firstWordWidth":I
    :goto_0
    return v24

    .line 129
    :cond_0
    const/16 v24, 0xff

    const-wide v25, 0x406fe00000000000L    # 255.0

    move/from16 v0, p3

    float-to-double v0, v0

    move-wide/from16 v27, v0

    mul-double v25, v25, v27

    move-wide/from16 v0, v25

    double-to-int v0, v0

    move/from16 v25, v0

    const-wide v26, 0x406fe00000000000L    # 255.0

    move/from16 v0, p4

    float-to-double v0, v0

    move-wide/from16 v28, v0

    mul-double v26, v26, v28

    move-wide/from16 v0, v26

    double-to-int v0, v0

    move/from16 v26, v0

    const-wide v27, 0x406fe00000000000L    # 255.0

    move/from16 v0, p5

    float-to-double v0, v0

    move-wide/from16 v29, v0

    mul-double v27, v27, v29

    move-wide/from16 v0, v27

    double-to-int v0, v0

    move/from16 v27, v0

    move-object/from16 v0, v16

    move/from16 v1, v24

    move/from16 v2, v25

    move/from16 v3, v26

    move/from16 v4, v27

    invoke-virtual {v0, v1, v2, v3, v4}, Landroid/graphics/Paint;->setARGB(IIII)V

    .line 131
    move-object/from16 v0, p0

    move/from16 v1, p7

    move/from16 v2, p8

    move-object/from16 v3, v16

    invoke-static {v0, v1, v2, v3}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->computeTextProperty(Ljava/lang/String;IILandroid/graphics/Paint;)Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;

    move-result-object v20

    .line 132
    .local v20, "textProperty":Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;
    if-nez p8, :cond_2

    invoke-static/range {v20 .. v20}, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;->access$0(Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;)I

    move-result v8

    .line 135
    .local v8, "bitmapTotalHeight":I
    :goto_1
    const/4 v6, 0x0

    .line 136
    .local v6, "bitmapPaddingX":F
    const/4 v7, 0x0

    .line 137
    .local v7, "bitmapPaddingY":F
    const/16 v18, 0x0

    .line 138
    .local v18, "renderTextDeltaX":F
    const/16 v19, 0x0

    .line 140
    .local v19, "renderTextDeltaY":F
    invoke-static/range {v20 .. v20}, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;->access$1(Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;)I

    move-result v24

    if-eqz v24, :cond_1

    if-nez v8, :cond_3

    .line 142
    :cond_1
    const-string v24, "createTextBitmapShadowStroke warning:"

    const-string v25, "textProperty MaxWidth is 0 or bitMapTotalHeight is 0\n"

    invoke-static/range {v24 .. v25}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 143
    const/16 v24, 0x0

    goto :goto_0

    .end local v6    # "bitmapPaddingX":F
    .end local v7    # "bitmapPaddingY":F
    .end local v8    # "bitmapTotalHeight":I
    .end local v18    # "renderTextDeltaX":F
    .end local v19    # "renderTextDeltaY":F
    :cond_2
    move/from16 v8, p8

    .line 132
    goto :goto_1

    .line 147
    .restart local v6    # "bitmapPaddingX":F
    .restart local v7    # "bitmapPaddingY":F
    .restart local v8    # "bitmapTotalHeight":I
    .restart local v18    # "renderTextDeltaX":F
    .restart local v19    # "renderTextDeltaY":F
    :cond_3
    invoke-static/range {v20 .. v20}, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;->access$1(Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;)I

    move-result v24

    float-to-int v0, v6

    move/from16 v25, v0

    add-int v24, v24, v25

    .line 148
    float-to-int v0, v7

    move/from16 v25, v0

    add-int v25, v25, v8

    sget-object v26, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    .line 147
    invoke-static/range {v24 .. v26}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v5

    .line 150
    .local v5, "bitmap":Landroid/graphics/Bitmap;
    new-instance v9, Landroid/graphics/Canvas;

    invoke-direct {v9, v5}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 153
    .local v9, "canvas":Landroid/graphics/Canvas;
    invoke-virtual/range {v16 .. v16}, Landroid/graphics/Paint;->getFontMetricsInt()Landroid/graphics/Paint$FontMetricsInt;

    move-result-object v11

    .line 156
    .local v11, "fontMetricsInt":Landroid/graphics/Paint$FontMetricsInt;
    if-eqz p14, :cond_6

    .line 158
    move-object/from16 v0, p1

    move/from16 v1, p2

    invoke-static {v0, v1, v12}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->newPaint(Ljava/lang/String;II)Landroid/graphics/Paint;

    move-result-object v17

    .line 159
    .local v17, "paintStroke":Landroid/graphics/Paint;
    sget-object v24, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;

    move-object/from16 v0, v17

    move-object/from16 v1, v24

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 160
    move-object/from16 v0, v17

    move/from16 v1, p18

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 161
    const/16 v24, 0xff

    const/high16 v25, 0x437f0000    # 255.0f

    mul-float v25, v25, p15

    move/from16 v0, v25

    float-to-int v0, v0

    move/from16 v25, v0

    const/high16 v26, 0x437f0000    # 255.0f

    mul-float v26, v26, p16

    move/from16 v0, v26

    float-to-int v0, v0

    move/from16 v26, v0

    const/high16 v27, 0x437f0000    # 255.0f

    mul-float v27, v27, p17

    move/from16 v0, v27

    float-to-int v0, v0

    move/from16 v27, v0

    move-object/from16 v0, v17

    move/from16 v1, v24

    move/from16 v2, v25

    move/from16 v3, v26

    move/from16 v4, v27

    invoke-virtual {v0, v1, v2, v3, v4}, Landroid/graphics/Paint;->setARGB(IIII)V

    .line 163
    const/16 v22, 0x0

    .line 164
    .local v22, "x":I
    invoke-static/range {v20 .. v20}, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;->access$0(Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;)I

    move-result v24

    move/from16 v0, p8

    move/from16 v1, v24

    move/from16 v2, v21

    invoke-static {v11, v0, v1, v2}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->computeY(Landroid/graphics/Paint$FontMetricsInt;III)I

    move-result v23

    .line 165
    .local v23, "y":I
    invoke-static/range {v20 .. v20}, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;->access$2(Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;)[Ljava/lang/String;

    move-result-object v15

    .line 167
    .local v15, "lines2":[Ljava/lang/String;
    array-length v0, v15

    move/from16 v25, v0

    const/16 v24, 0x0

    :goto_2
    move/from16 v0, v24

    move/from16 v1, v25

    if-lt v0, v1, :cond_5

    .line 193
    .end local v15    # "lines2":[Ljava/lang/String;
    .end local v17    # "paintStroke":Landroid/graphics/Paint;
    :cond_4
    invoke-static {v5}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->initNativeObject(Landroid/graphics/Bitmap;)V

    .line 195
    const/16 v24, 0x1

    goto/16 :goto_0

    .line 167
    .restart local v15    # "lines2":[Ljava/lang/String;
    .restart local v17    # "paintStroke":Landroid/graphics/Paint;
    :cond_5
    aget-object v13, v15, v24

    .line 169
    .local v13, "line":Ljava/lang/String;
    invoke-static/range {v20 .. v20}, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;->access$1(Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;)I

    move-result v26

    move/from16 v0, v26

    invoke-static {v13, v0, v12}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->computeX(Ljava/lang/String;II)I

    move-result v22

    .line 170
    move/from16 v0, v22

    int-to-float v0, v0

    move/from16 v26, v0

    add-float v26, v26, v18

    move/from16 v0, v23

    int-to-float v0, v0

    move/from16 v27, v0

    add-float v27, v27, v19

    move/from16 v0, v26

    move/from16 v1, v27

    move-object/from16 v2, v17

    invoke-virtual {v9, v13, v0, v1, v2}, Landroid/graphics/Canvas;->drawText(Ljava/lang/String;FFLandroid/graphics/Paint;)V

    .line 171
    move/from16 v0, v22

    int-to-float v0, v0

    move/from16 v26, v0

    add-float v26, v26, v18

    move/from16 v0, v23

    int-to-float v0, v0

    move/from16 v27, v0

    add-float v27, v27, v19

    move/from16 v0, v26

    move/from16 v1, v27

    move-object/from16 v2, v16

    invoke-virtual {v9, v13, v0, v1, v2}, Landroid/graphics/Canvas;->drawText(Ljava/lang/String;FFLandroid/graphics/Paint;)V

    .line 172
    invoke-static/range {v20 .. v20}, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;->access$3(Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;)I

    move-result v26

    add-int v23, v23, v26

    .line 167
    add-int/lit8 v24, v24, 0x1

    goto :goto_2

    .line 179
    .end local v13    # "line":Ljava/lang/String;
    .end local v15    # "lines2":[Ljava/lang/String;
    .end local v17    # "paintStroke":Landroid/graphics/Paint;
    .end local v22    # "x":I
    .end local v23    # "y":I
    :cond_6
    const/16 v22, 0x0

    .line 180
    .restart local v22    # "x":I
    invoke-static/range {v20 .. v20}, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;->access$0(Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;)I

    move-result v24

    move/from16 v0, p8

    move/from16 v1, v24

    move/from16 v2, v21

    invoke-static {v11, v0, v1, v2}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->computeY(Landroid/graphics/Paint$FontMetricsInt;III)I

    move-result v23

    .line 182
    .restart local v23    # "y":I
    invoke-static/range {v20 .. v20}, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;->access$2(Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;)[Ljava/lang/String;

    move-result-object v14

    .line 184
    .local v14, "lines":[Ljava/lang/String;
    array-length v0, v14

    move/from16 v25, v0

    const/16 v24, 0x0

    :goto_3
    move/from16 v0, v24

    move/from16 v1, v25

    if-ge v0, v1, :cond_4

    aget-object v13, v14, v24

    .line 186
    .restart local v13    # "line":Ljava/lang/String;
    invoke-static/range {v20 .. v20}, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;->access$1(Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;)I

    move-result v26

    move/from16 v0, v26

    invoke-static {v13, v0, v12}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->computeX(Ljava/lang/String;II)I

    move-result v22

    .line 187
    move/from16 v0, v22

    int-to-float v0, v0

    move/from16 v26, v0

    add-float v26, v26, v18

    move/from16 v0, v23

    int-to-float v0, v0

    move/from16 v27, v0

    add-float v27, v27, v19

    move/from16 v0, v26

    move/from16 v1, v27

    move-object/from16 v2, v16

    invoke-virtual {v9, v13, v0, v1, v2}, Landroid/graphics/Canvas;->drawText(Ljava/lang/String;FFLandroid/graphics/Paint;)V

    .line 188
    invoke-static/range {v20 .. v20}, Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;->access$3(Lorg/cocos2dx/lib/Cocos2dxBitmap$TextProperty;)I

    move-result v26

    add-int v23, v23, v26

    .line 184
    add-int/lit8 v24, v24, 0x1

    goto :goto_3
.end method

.method private static divideStringWithMaxWidth(Ljava/lang/String;ILandroid/graphics/Paint;)Ljava/util/LinkedList;
    .locals 8
    .param p0, "string"    # Ljava/lang/String;
    .param p1, "maxWidth"    # I
    .param p2, "paint"    # Landroid/graphics/Paint;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "I",
            "Landroid/graphics/Paint;",
            ")",
            "Ljava/util/LinkedList",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .prologue
    .line 368
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    .line 369
    .local v0, "charLength":I
    const/4 v3, 0x0

    .line 370
    .local v3, "start":I
    const/4 v5, 0x0

    .line 371
    .local v5, "tempWidth":I
    new-instance v4, Ljava/util/LinkedList;

    invoke-direct {v4}, Ljava/util/LinkedList;-><init>()V

    .line 374
    .local v4, "strList":Ljava/util/LinkedList;, "Ljava/util/LinkedList<Ljava/lang/String;>;"
    const/4 v1, 0x1

    .local v1, "i":I
    :goto_0
    if-le v1, v0, :cond_1

    .line 406
    if-ge v3, v0, :cond_0

    .line 407
    invoke-virtual {p0, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/util/LinkedList;->add(Ljava/lang/Object;)Z

    .line 410
    :cond_0
    return-object v4

    .line 375
    :cond_1
    invoke-virtual {p2, p0, v3, v1}, Landroid/graphics/Paint;->measureText(Ljava/lang/String;II)F

    move-result v6

    float-to-double v6, v6

    invoke-static {v6, v7}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v6

    double-to-int v5, v6

    .line 377
    if-lt v5, p1, :cond_3

    .line 378
    const/4 v6, 0x0

    invoke-virtual {p0, v6, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v6

    .line 379
    const-string v7, " "

    invoke-virtual {v6, v7}, Ljava/lang/String;->lastIndexOf(Ljava/lang/String;)I

    move-result v2

    .line 381
    .local v2, "lastIndexOfSpace":I
    const/4 v6, -0x1

    if-eq v2, v6, :cond_4

    if-le v2, v3, :cond_4

    .line 383
    invoke-virtual {p0, v3, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/util/LinkedList;->add(Ljava/lang/Object;)Z

    .line 384
    add-int/lit8 v1, v2, 0x1

    .line 397
    :goto_1
    if-ge v1, v0, :cond_2

    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v6

    const/16 v7, 0x20

    if-eq v6, v7, :cond_6

    .line 401
    :cond_2
    move v3, v1

    .line 374
    .end local v2    # "lastIndexOfSpace":I
    :cond_3
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 387
    .restart local v2    # "lastIndexOfSpace":I
    :cond_4
    if-le v5, p1, :cond_5

    .line 388
    add-int/lit8 v6, v1, -0x1

    invoke-virtual {p0, v3, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/util/LinkedList;->add(Ljava/lang/Object;)Z

    .line 390
    add-int/lit8 v1, v1, -0x1

    .line 391
    goto :goto_1

    .line 392
    :cond_5
    invoke-virtual {p0, v3, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/util/LinkedList;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 398
    :cond_6
    add-int/lit8 v1, v1, 0x1

    goto :goto_1
.end method

.method private static getFontSizeAccordingHeight(I)I
    .locals 8
    .param p0, "height"    # I

    .prologue
    .line 468
    new-instance v3, Landroid/graphics/Paint;

    invoke-direct {v3}, Landroid/graphics/Paint;-><init>()V

    .line 469
    .local v3, "paint":Landroid/graphics/Paint;
    new-instance v0, Landroid/graphics/Rect;

    invoke-direct {v0}, Landroid/graphics/Rect;-><init>()V

    .line 471
    .local v0, "bounds":Landroid/graphics/Rect;
    sget-object v5, Landroid/graphics/Typeface;->DEFAULT:Landroid/graphics/Typeface;

    invoke-virtual {v3, v5}, Landroid/graphics/Paint;->setTypeface(Landroid/graphics/Typeface;)Landroid/graphics/Typeface;

    .line 472
    const/4 v2, 0x1

    .line 473
    .local v2, "incr_text_size":I
    const/4 v1, 0x0

    .line 475
    .local v1, "found_desired_size":Z
    :goto_0
    if-eqz v1, :cond_0

    .line 488
    return v2

    .line 477
    :cond_0
    int-to-float v5, v2

    invoke-virtual {v3, v5}, Landroid/graphics/Paint;->setTextSize(F)V

    .line 478
    const-string v4, "SghMNy"

    .line 479
    .local v4, "text":Ljava/lang/String;
    const/4 v5, 0x0

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v6

    invoke-virtual {v3, v4, v5, v6, v0}, Landroid/graphics/Paint;->getTextBounds(Ljava/lang/String;IILandroid/graphics/Rect;)V

    .line 481
    add-int/lit8 v2, v2, 0x1

    .line 483
    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I

    move-result v5

    sub-int v5, p0, v5

    const/4 v6, 0x2

    if-gt v5, v6, :cond_1

    .line 484
    const/4 v1, 0x1

    .line 486
    :cond_1
    const-string v5, "font size"

    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "incr size:"

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method private static getPixels(Landroid/graphics/Bitmap;)[B
    .locals 4
    .param p0, "bitmap"    # Landroid/graphics/Bitmap;

    .prologue
    .line 455
    if-eqz p0, :cond_0

    .line 456
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v2

    .line 457
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v3

    .line 456
    mul-int/2addr v2, v3

    mul-int/lit8 v2, v2, 0x4

    new-array v1, v2, [B

    .line 458
    .local v1, "pixels":[B
    invoke-static {v1}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v0

    .line 459
    .local v0, "buf":Ljava/nio/ByteBuffer;
    invoke-static {}, Ljava/nio/ByteOrder;->nativeOrder()Ljava/nio/ByteOrder;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/nio/ByteBuffer;->order(Ljava/nio/ByteOrder;)Ljava/nio/ByteBuffer;

    .line 460
    invoke-virtual {p0, v0}, Landroid/graphics/Bitmap;->copyPixelsToBuffer(Ljava/nio/Buffer;)V

    .line 464
    .end local v0    # "buf":Ljava/nio/ByteBuffer;
    .end local v1    # "pixels":[B
    :goto_0
    return-object v1

    :cond_0
    const/4 v1, 0x0

    goto :goto_0
.end method

.method private static getStringWithEllipsis(Ljava/lang/String;FF)Ljava/lang/String;
    .locals 2
    .param p0, "string"    # Ljava/lang/String;
    .param p1, "width"    # F
    .param p2, "fontSize"    # F

    .prologue
    .line 493
    invoke-static {p0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 494
    const-string v1, ""

    .line 501
    :goto_0
    return-object v1

    .line 497
    :cond_0
    new-instance v0, Landroid/text/TextPaint;

    invoke-direct {v0}, Landroid/text/TextPaint;-><init>()V

    .line 498
    .local v0, "paint":Landroid/text/TextPaint;
    sget-object v1, Landroid/graphics/Typeface;->DEFAULT:Landroid/graphics/Typeface;

    invoke-virtual {v0, v1}, Landroid/text/TextPaint;->setTypeface(Landroid/graphics/Typeface;)Landroid/graphics/Typeface;

    .line 499
    invoke-virtual {v0, p2}, Landroid/text/TextPaint;->setTextSize(F)V

    .line 502
    sget-object v1, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    .line 501
    invoke-static {p0, v0, p1, v1}, Landroid/text/TextUtils;->ellipsize(Ljava/lang/CharSequence;Landroid/text/TextPaint;FLandroid/text/TextUtils$TruncateAt;)Ljava/lang/CharSequence;

    move-result-object v1

    .line 502
    invoke-interface {v1}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_0
.end method

.method private static initNativeObject(Landroid/graphics/Bitmap;)V
    .locals 3
    .param p0, "bitmap"    # Landroid/graphics/Bitmap;

    .prologue
    .line 445
    invoke-static {p0}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->getPixels(Landroid/graphics/Bitmap;)[B

    move-result-object v0

    .line 446
    .local v0, "pixels":[B
    if-nez v0, :cond_0

    .line 452
    :goto_0
    return-void

    .line 450
    :cond_0
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v1

    .line 451
    invoke-virtual {p0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v2

    .line 450
    invoke-static {v1, v2, v0}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->nativeInitBitmapDC(II[B)V

    goto :goto_0
.end method

.method private static native nativeInitBitmapDC(II[B)V
.end method

.method private static newPaint(Ljava/lang/String;II)Landroid/graphics/Paint;
    .locals 7
    .param p0, "fontName"    # Ljava/lang/String;
    .param p1, "fontSize"    # I
    .param p2, "horizontalAlignment"    # I

    .prologue
    const/4 v6, 0x0

    .line 200
    new-instance v1, Landroid/graphics/Paint;

    invoke-direct {v1}, Landroid/graphics/Paint;-><init>()V

    .line 201
    .local v1, "paint":Landroid/graphics/Paint;
    const/4 v3, -0x1

    invoke-virtual {v1, v3}, Landroid/graphics/Paint;->setColor(I)V

    .line 202
    int-to-float v3, p1

    invoke-virtual {v1, v3}, Landroid/graphics/Paint;->setTextSize(F)V

    .line 203
    const/4 v3, 0x1

    invoke-virtual {v1, v3}, Landroid/graphics/Paint;->setAntiAlias(Z)V

    .line 206
    const-string v3, ".ttf"

    invoke-virtual {p0, v3}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_0

    .line 209
    :try_start_0
    sget-object v3, Lorg/cocos2dx/lib/Cocos2dxBitmap;->sContext:Landroid/content/Context;

    .line 208
    invoke-static {v3, p0}, Lorg/cocos2dx/lib/Cocos2dxTypefaces;->get(Landroid/content/Context;Ljava/lang/String;)Landroid/graphics/Typeface;

    move-result-object v2

    .line 210
    .local v2, "typeFace":Landroid/graphics/Typeface;
    invoke-virtual {v1, v2}, Landroid/graphics/Paint;->setTypeface(Landroid/graphics/Typeface;)Landroid/graphics/Typeface;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 222
    .end local v2    # "typeFace":Landroid/graphics/Typeface;
    :goto_0
    packed-switch p2, :pswitch_data_0

    .line 231
    sget-object v3, Landroid/graphics/Paint$Align;->LEFT:Landroid/graphics/Paint$Align;

    invoke-virtual {v1, v3}, Landroid/graphics/Paint;->setTextAlign(Landroid/graphics/Paint$Align;)V

    .line 235
    :goto_1
    return-object v1

    .line 211
    :catch_0
    move-exception v0

    .line 212
    .local v0, "e":Ljava/lang/Exception;
    const-string v3, "Cocos2dxBitmap"

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "error to create ttf type face: "

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 213
    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 212
    invoke-static {v3, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 216
    invoke-static {p0, v6}, Landroid/graphics/Typeface;->create(Ljava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/graphics/Paint;->setTypeface(Landroid/graphics/Typeface;)Landroid/graphics/Typeface;

    goto :goto_0

    .line 219
    .end local v0    # "e":Ljava/lang/Exception;
    :cond_0
    invoke-static {p0, v6}, Landroid/graphics/Typeface;->create(Ljava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/graphics/Paint;->setTypeface(Landroid/graphics/Typeface;)Landroid/graphics/Typeface;

    goto :goto_0

    .line 224
    :pswitch_0
    sget-object v3, Landroid/graphics/Paint$Align;->CENTER:Landroid/graphics/Paint$Align;

    invoke-virtual {v1, v3}, Landroid/graphics/Paint;->setTextAlign(Landroid/graphics/Paint$Align;)V

    goto :goto_1

    .line 227
    :pswitch_1
    sget-object v3, Landroid/graphics/Paint$Align;->RIGHT:Landroid/graphics/Paint$Align;

    invoke-virtual {v1, v3}, Landroid/graphics/Paint;->setTextAlign(Landroid/graphics/Paint$Align;)V

    goto :goto_1

    .line 222
    nop

    :pswitch_data_0
    .packed-switch 0x2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private static refactorString(Ljava/lang/String;)Ljava/lang/String;
    .locals 5
    .param p0, "string"    # Ljava/lang/String;

    .prologue
    .line 415
    const-string v3, ""

    invoke-virtual {p0, v3}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result v3

    if-nez v3, :cond_0

    .line 416
    const-string v3, " "

    .line 441
    :goto_0
    return-object v3

    .line 423
    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 424
    .local v2, "strBuilder":Ljava/lang/StringBuilder;
    const/4 v1, 0x0

    .line 425
    .local v1, "start":I
    const-string v3, "\n"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->indexOf(Ljava/lang/String;)I

    move-result v0

    .line 426
    .local v0, "index":I
    :goto_1
    const/4 v3, -0x1

    if-ne v0, v3, :cond_2

    .line 441
    :cond_1
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    goto :goto_0

    .line 427
    :cond_2
    if-eqz v0, :cond_3

    add-int/lit8 v3, v0, -0x1

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->charAt(I)C

    move-result v3

    const/16 v4, 0xa

    if-ne v3, v4, :cond_4

    .line 428
    :cond_3
    const-string v3, " "

    invoke-virtual {v2, v1, v3}, Ljava/lang/StringBuilder;->insert(ILjava/lang/String;)Ljava/lang/StringBuilder;

    .line 429
    add-int/lit8 v1, v0, 0x2

    .line 434
    :goto_2
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    if-gt v1, v3, :cond_1

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->length()I

    move-result v3

    if-eq v0, v3, :cond_1

    .line 438
    const-string v3, "\n"

    invoke-virtual {v2, v3, v1}, Ljava/lang/StringBuilder;->indexOf(Ljava/lang/String;I)I

    move-result v0

    goto :goto_1

    .line 431
    :cond_4
    add-int/lit8 v1, v0, 0x1

    goto :goto_2
.end method

.method public static setContext(Landroid/content/Context;)V
    .locals 0
    .param p0, "context"    # Landroid/content/Context;

    .prologue
    .line 72
    sput-object p0, Lorg/cocos2dx/lib/Cocos2dxBitmap;->sContext:Landroid/content/Context;

    .line 73
    return-void
.end method

.method private static splitString(Ljava/lang/String;IILandroid/graphics/Paint;)[Ljava/lang/String;
    .locals 14
    .param p0, "string"    # Ljava/lang/String;
    .param p1, "maxWidth"    # I
    .param p2, "maxHeight"    # I
    .param p3, "paint"    # Landroid/graphics/Paint;

    .prologue
    .line 314
    const-string v10, "\\n"

    invoke-virtual {p0, v10}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v6

    .line 315
    .local v6, "lines":[Ljava/lang/String;
    const/4 v8, 0x0

    .line 316
    .local v8, "ret":[Ljava/lang/String;
    invoke-virtual/range {p3 .. p3}, Landroid/graphics/Paint;->getFontMetricsInt()Landroid/graphics/Paint$FontMetricsInt;

    move-result-object v1

    .line 317
    .local v1, "fm":Landroid/graphics/Paint$FontMetricsInt;
    iget v10, v1, Landroid/graphics/Paint$FontMetricsInt;->bottom:I

    iget v11, v1, Landroid/graphics/Paint$FontMetricsInt;->top:I

    sub-int/2addr v10, v11

    int-to-double v10, v10

    invoke-static {v10, v11}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v10

    double-to-int v2, v10

    .line 318
    .local v2, "heightPerLine":I
    div-int v7, p2, v2

    .line 320
    .local v7, "maxLines":I
    if-eqz p1, :cond_6

    .line 321
    new-instance v9, Ljava/util/LinkedList;

    invoke-direct {v9}, Ljava/util/LinkedList;-><init>()V

    .line 322
    .local v9, "strList":Ljava/util/LinkedList;, "Ljava/util/LinkedList<Ljava/lang/String;>;"
    array-length v11, v6

    const/4 v10, 0x0

    :goto_0
    if-lt v10, v11, :cond_2

    .line 343
    :cond_0
    if-lez v7, :cond_1

    invoke-virtual {v9}, Ljava/util/LinkedList;->size()I

    move-result v10

    if-le v10, v7, :cond_1

    .line 344
    :goto_1
    invoke-virtual {v9}, Ljava/util/LinkedList;->size()I

    move-result v10

    if-gt v10, v7, :cond_5

    .line 349
    :cond_1
    invoke-virtual {v9}, Ljava/util/LinkedList;->size()I

    move-result v10

    new-array v8, v10, [Ljava/lang/String;

    .line 350
    invoke-virtual {v9, v8}, Ljava/util/LinkedList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    .line 363
    .end local v9    # "strList":Ljava/util/LinkedList;, "Ljava/util/LinkedList<Ljava/lang/String;>;"
    :goto_2
    return-object v8

    .line 322
    .restart local v9    # "strList":Ljava/util/LinkedList;, "Ljava/util/LinkedList<Ljava/lang/String;>;"
    :cond_2
    aget-object v4, v6, v10

    .line 328
    .local v4, "line":Ljava/lang/String;
    move-object/from16 v0, p3

    invoke-virtual {v0, v4}, Landroid/graphics/Paint;->measureText(Ljava/lang/String;)F

    move-result v12

    float-to-double v12, v12

    .line 327
    invoke-static {v12, v13}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v12

    double-to-int v5, v12

    .line 329
    .local v5, "lineWidth":I
    if-le v5, p1, :cond_4

    .line 330
    move-object/from16 v0, p3

    invoke-static {v4, p1, v0}, Lorg/cocos2dx/lib/Cocos2dxBitmap;->divideStringWithMaxWidth(Ljava/lang/String;ILandroid/graphics/Paint;)Ljava/util/LinkedList;

    move-result-object v12

    invoke-virtual {v9, v12}, Ljava/util/LinkedList;->addAll(Ljava/util/Collection;)Z

    .line 337
    :goto_3
    if-lez v7, :cond_3

    invoke-virtual {v9}, Ljava/util/LinkedList;->size()I

    move-result v12

    if-ge v12, v7, :cond_0

    .line 322
    :cond_3
    add-int/lit8 v10, v10, 0x1

    goto :goto_0

    .line 333
    :cond_4
    invoke-virtual {v9, v4}, Ljava/util/LinkedList;->add(Ljava/lang/Object;)Z

    goto :goto_3

    .line 345
    .end local v4    # "line":Ljava/lang/String;
    .end local v5    # "lineWidth":I
    :cond_5
    invoke-virtual {v9}, Ljava/util/LinkedList;->removeLast()Ljava/lang/Object;

    goto :goto_1

    .line 351
    .end local v9    # "strList":Ljava/util/LinkedList;, "Ljava/util/LinkedList<Ljava/lang/String;>;"
    :cond_6
    if-eqz p2, :cond_8

    array-length v10, v6

    if-le v10, v7, :cond_8

    .line 353
    new-instance v9, Ljava/util/LinkedList;

    invoke-direct {v9}, Ljava/util/LinkedList;-><init>()V

    .line 354
    .restart local v9    # "strList":Ljava/util/LinkedList;, "Ljava/util/LinkedList<Ljava/lang/String;>;"
    const/4 v3, 0x0

    .local v3, "i":I
    :goto_4
    if-lt v3, v7, :cond_7

    .line 357
    invoke-virtual {v9}, Ljava/util/LinkedList;->size()I

    move-result v10

    new-array v8, v10, [Ljava/lang/String;

    .line 358
    invoke-virtual {v9, v8}, Ljava/util/LinkedList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    goto :goto_2

    .line 355
    :cond_7
    aget-object v10, v6, v3

    invoke-virtual {v9, v10}, Ljava/util/LinkedList;->add(Ljava/lang/Object;)Z

    .line 354
    add-int/lit8 v3, v3, 0x1

    goto :goto_4

    .line 360
    .end local v3    # "i":I
    .end local v9    # "strList":Ljava/util/LinkedList;, "Ljava/util/LinkedList<Ljava/lang/String;>;"
    :cond_8
    move-object v8, v6

    goto :goto_2
.end method
