.class public Lcn/uc/gamesdk/d/b/d;
.super Ljava/lang/Object;


# static fields
.field public static final a:I = -0x1

.field public static final b:I = -0x2

.field public static final c:I = -0x3

.field public static final d:I = 0x0

.field public static final e:I = -0x1

.field public static final f:I = 0x8

.field public static final g:I = 0xa


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static final a([B[I)I
    .locals 13

    const/4 v12, 0x3

    const/16 v1, 0x8

    const/4 v11, 0x2

    const/4 v10, 0x1

    const/4 v0, 0x0

    if-nez p0, :cond_1

    const/4 v0, -0x1

    :cond_0
    :goto_0
    return v0

    :cond_1
    array-length v3, p0

    const/16 v2, 0xa

    if-lt v3, v2, :cond_2

    aget-byte v2, p0, v0

    const/16 v4, 0x6d

    if-ne v2, v4, :cond_2

    aget-byte v2, p0, v10

    const/16 v4, 0x39

    if-ne v2, v4, :cond_2

    aget-byte v2, p0, v11

    const/16 v4, 0x30

    if-eq v2, v4, :cond_3

    :cond_2
    const/4 v0, -0x2

    goto :goto_0

    :cond_3
    new-array v4, v1, [I

    invoke-static {p1, v0, v4, v0, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    new-array v5, v1, [I

    invoke-static {p1, v1, v5, v0, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    new-array v6, v1, [B

    const/4 v2, 0x4

    aget-byte v2, p0, v2

    aput-byte v2, v6, v0

    const/4 v2, 0x5

    aget-byte v2, p0, v2

    aput-byte v2, v6, v10

    const/4 v2, 0x6

    aget-byte v2, p0, v2

    aput-byte v2, v6, v11

    const/4 v2, 0x7

    aget-byte v2, p0, v2

    aput-byte v2, v6, v12

    const/4 v2, 0x4

    aget-byte v7, v6, v0

    add-int/lit8 v7, v7, 0x57

    rem-int/lit16 v7, v7, 0x100

    int-to-byte v7, v7

    aput-byte v7, v6, v2

    const/4 v2, 0x5

    aget-byte v7, v6, v10

    add-int/lit8 v7, v7, 0x1d

    rem-int/lit16 v7, v7, 0x100

    int-to-byte v7, v7

    aput-byte v7, v6, v2

    const/4 v2, 0x6

    aget-byte v7, v6, v11

    add-int/lit16 v7, v7, 0xab

    rem-int/lit16 v7, v7, 0x100

    int-to-byte v7, v7

    aput-byte v7, v6, v2

    const/4 v2, 0x7

    aget-byte v7, v6, v12

    add-int/lit16 v7, v7, 0x94

    rem-int/lit16 v7, v7, 0x100

    int-to-byte v7, v7

    aput-byte v7, v6, v2

    move v2, v0

    :goto_1
    add-int/lit8 v7, v3, -0x2

    if-ge v1, v7, :cond_5

    rem-int/lit8 v7, v1, 0x8

    if-nez v7, :cond_4

    aget v7, v4, v0

    aget v8, v5, v0

    add-int/2addr v7, v8

    aget-byte v8, v6, v0

    add-int/2addr v7, v8

    rem-int/lit16 v7, v7, 0x100

    aput v7, v4, v0

    aget v7, v4, v10

    aget v8, v5, v10

    add-int/2addr v7, v8

    aget-byte v8, v6, v10

    add-int/2addr v7, v8

    rem-int/lit16 v7, v7, 0x100

    aput v7, v4, v10

    aget v7, v4, v11

    aget v8, v5, v11

    add-int/2addr v7, v8

    aget-byte v8, v6, v11

    add-int/2addr v7, v8

    rem-int/lit16 v7, v7, 0x100

    aput v7, v4, v11

    aget v7, v4, v12

    aget v8, v5, v12

    add-int/2addr v7, v8

    aget-byte v8, v6, v12

    add-int/2addr v7, v8

    rem-int/lit16 v7, v7, 0x100

    aput v7, v4, v12

    const/4 v7, 0x4

    const/4 v8, 0x4

    aget v8, v4, v8

    const/4 v9, 0x4

    aget v9, v5, v9

    add-int/2addr v8, v9

    const/4 v9, 0x4

    aget-byte v9, v6, v9

    add-int/2addr v8, v9

    rem-int/lit16 v8, v8, 0x100

    aput v8, v4, v7

    const/4 v7, 0x5

    const/4 v8, 0x5

    aget v8, v4, v8

    const/4 v9, 0x5

    aget v9, v5, v9

    add-int/2addr v8, v9

    const/4 v9, 0x5

    aget-byte v9, v6, v9

    add-int/2addr v8, v9

    rem-int/lit16 v8, v8, 0x100

    aput v8, v4, v7

    const/4 v7, 0x6

    const/4 v8, 0x6

    aget v8, v4, v8

    const/4 v9, 0x6

    aget v9, v5, v9

    add-int/2addr v8, v9

    const/4 v9, 0x6

    aget-byte v9, v6, v9

    add-int/2addr v8, v9

    rem-int/lit16 v8, v8, 0x100

    aput v8, v4, v7

    const/4 v7, 0x7

    const/4 v8, 0x7

    aget v8, v4, v8

    const/4 v9, 0x7

    aget v9, v5, v9

    add-int/2addr v8, v9

    const/4 v9, 0x7

    aget-byte v9, v6, v9

    add-int/2addr v8, v9

    rem-int/lit16 v8, v8, 0x100

    aput v8, v4, v7

    :cond_4
    aget-byte v7, p0, v1

    rem-int/lit8 v8, v1, 0x8

    aget v8, v4, v8

    xor-int/2addr v7, v8

    and-int/lit16 v8, v7, 0xff

    int-to-byte v8, v8

    aput-byte v8, p0, v1

    xor-int/2addr v2, v7

    add-int/lit8 v1, v1, 0x1

    goto/16 :goto_1

    :cond_5
    add-int/lit8 v1, v3, -0x2

    aget-byte v1, p0, v1

    aget v5, v4, v0

    xor-int/2addr v5, v2

    and-int/lit16 v5, v5, 0xff

    int-to-byte v5, v5

    if-ne v1, v5, :cond_6

    add-int/lit8 v1, v3, -0x1

    aget-byte v1, p0, v1

    aget v3, v4, v10

    xor-int/2addr v2, v3

    and-int/lit16 v2, v2, 0xff

    int-to-byte v2, v2

    if-eq v1, v2, :cond_0

    :cond_6
    const/4 v0, -0x3

    goto/16 :goto_0
.end method

.method public static a([B)Z
    .locals 4

    const/4 v1, 0x1

    const/4 v0, 0x0

    if-nez p0, :cond_1

    :cond_0
    :goto_0
    return v0

    :cond_1
    array-length v2, p0

    const/4 v3, 0x2

    if-lt v2, v3, :cond_0

    aget-byte v2, p0, v0

    int-to-char v2, v2

    const/16 v3, 0x6d

    if-ne v2, v3, :cond_0

    aget-byte v2, p0, v1

    int-to-char v2, v2

    const/16 v3, 0x39

    if-ne v2, v3, :cond_0

    move v0, v1

    goto :goto_0
.end method

.method public static final a(I[B[I)[B
    .locals 10

    const/16 v0, 0x8

    new-array v2, v0, [I

    const/4 v0, 0x0

    const/4 v1, 0x0

    const/16 v3, 0x8

    invoke-static {p2, v0, v2, v1, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    const/16 v0, 0x8

    new-array v3, v0, [I

    const/16 v0, 0x8

    const/4 v1, 0x0

    const/16 v4, 0x8

    invoke-static {p2, v0, v3, v1, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    const/16 v0, 0x8

    new-array v4, v0, [B

    new-instance v0, Ljava/util/Random;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    invoke-direct {v0, v5, v6}, Ljava/util/Random;-><init>(J)V

    invoke-virtual {v0}, Ljava/util/Random;->nextInt()I

    move-result v0

    const/4 v1, 0x0

    shr-int/lit8 v5, v0, 0x18

    and-int/lit16 v5, v5, 0xff

    int-to-byte v5, v5

    aput-byte v5, v4, v1

    const/4 v1, 0x1

    shr-int/lit8 v5, v0, 0x10

    and-int/lit16 v5, v5, 0xff

    int-to-byte v5, v5

    aput-byte v5, v4, v1

    const/4 v1, 0x2

    shr-int/lit8 v5, v0, 0x8

    and-int/lit16 v5, v5, 0xff

    int-to-byte v5, v5

    aput-byte v5, v4, v1

    const/4 v1, 0x3

    and-int/lit16 v0, v0, 0xff

    int-to-byte v0, v0

    aput-byte v0, v4, v1

    const/4 v0, 0x4

    const/4 v1, 0x0

    aget-byte v1, v4, v1

    add-int/lit8 v1, v1, 0x57

    rem-int/lit16 v1, v1, 0x100

    int-to-byte v1, v1

    aput-byte v1, v4, v0

    const/4 v0, 0x5

    const/4 v1, 0x1

    aget-byte v1, v4, v1

    add-int/lit8 v1, v1, 0x1d

    rem-int/lit16 v1, v1, 0x100

    int-to-byte v1, v1

    aput-byte v1, v4, v0

    const/4 v0, 0x6

    const/4 v1, 0x2

    aget-byte v1, v4, v1

    add-int/lit16 v1, v1, 0xab

    rem-int/lit16 v1, v1, 0x100

    int-to-byte v1, v1

    aput-byte v1, v4, v0

    const/4 v0, 0x7

    const/4 v1, 0x3

    aget-byte v1, v4, v1

    add-int/lit16 v1, v1, 0x94

    rem-int/lit16 v1, v1, 0x100

    int-to-byte v1, v1

    aput-byte v1, v4, v0

    array-length v5, p1

    add-int/lit8 v0, v5, 0xa

    new-array v6, v0, [B

    const/4 v0, 0x0

    const/16 v1, 0x6d

    aput-byte v1, v6, v0

    const/4 v0, 0x1

    const/16 v1, 0x39

    aput-byte v1, v6, v0

    const/4 v0, 0x2

    const/16 v1, 0x30

    aput-byte v1, v6, v0

    const/4 v0, 0x3

    int-to-byte v1, p0

    aput-byte v1, v6, v0

    const/4 v0, 0x4

    const/4 v1, 0x0

    aget-byte v1, v4, v1

    aput-byte v1, v6, v0

    const/4 v0, 0x5

    const/4 v1, 0x1

    aget-byte v1, v4, v1

    aput-byte v1, v6, v0

    const/4 v0, 0x6

    const/4 v1, 0x2

    aget-byte v1, v4, v1

    aput-byte v1, v6, v0

    const/4 v0, 0x7

    const/4 v1, 0x3

    aget-byte v1, v4, v1

    aput-byte v1, v6, v0

    const/4 v1, 0x0

    const/4 v0, 0x0

    :goto_0
    if-ge v0, v5, :cond_1

    rem-int/lit8 v7, v0, 0x8

    if-nez v7, :cond_0

    const/4 v7, 0x0

    const/4 v8, 0x0

    aget v8, v2, v8

    const/4 v9, 0x0

    aget v9, v3, v9

    add-int/2addr v8, v9

    const/4 v9, 0x0

    aget-byte v9, v4, v9

    add-int/2addr v8, v9

    rem-int/lit16 v8, v8, 0x100

    aput v8, v2, v7

    const/4 v7, 0x1

    const/4 v8, 0x1

    aget v8, v2, v8

    const/4 v9, 0x1

    aget v9, v3, v9

    add-int/2addr v8, v9

    const/4 v9, 0x1

    aget-byte v9, v4, v9

    add-int/2addr v8, v9

    rem-int/lit16 v8, v8, 0x100

    aput v8, v2, v7

    const/4 v7, 0x2

    const/4 v8, 0x2

    aget v8, v2, v8

    const/4 v9, 0x2

    aget v9, v3, v9

    add-int/2addr v8, v9

    const/4 v9, 0x2

    aget-byte v9, v4, v9

    add-int/2addr v8, v9

    rem-int/lit16 v8, v8, 0x100

    aput v8, v2, v7

    const/4 v7, 0x3

    const/4 v8, 0x3

    aget v8, v2, v8

    const/4 v9, 0x3

    aget v9, v3, v9

    add-int/2addr v8, v9

    const/4 v9, 0x3

    aget-byte v9, v4, v9

    add-int/2addr v8, v9

    rem-int/lit16 v8, v8, 0x100

    aput v8, v2, v7

    const/4 v7, 0x4

    const/4 v8, 0x4

    aget v8, v2, v8

    const/4 v9, 0x4

    aget v9, v3, v9

    add-int/2addr v8, v9

    const/4 v9, 0x4

    aget-byte v9, v4, v9

    add-int/2addr v8, v9

    rem-int/lit16 v8, v8, 0x100

    aput v8, v2, v7

    const/4 v7, 0x5

    const/4 v8, 0x5

    aget v8, v2, v8

    const/4 v9, 0x5

    aget v9, v3, v9

    add-int/2addr v8, v9

    const/4 v9, 0x5

    aget-byte v9, v4, v9

    add-int/2addr v8, v9

    rem-int/lit16 v8, v8, 0x100

    aput v8, v2, v7

    const/4 v7, 0x6

    const/4 v8, 0x6

    aget v8, v2, v8

    const/4 v9, 0x6

    aget v9, v3, v9

    add-int/2addr v8, v9

    const/4 v9, 0x6

    aget-byte v9, v4, v9

    add-int/2addr v8, v9

    rem-int/lit16 v8, v8, 0x100

    aput v8, v2, v7

    const/4 v7, 0x7

    const/4 v8, 0x7

    aget v8, v2, v8

    const/4 v9, 0x7

    aget v9, v3, v9

    add-int/2addr v8, v9

    const/4 v9, 0x7

    aget-byte v9, v4, v9

    add-int/2addr v8, v9

    rem-int/lit16 v8, v8, 0x100

    aput v8, v2, v7

    :cond_0
    aget-byte v7, p1, v0

    and-int/lit16 v7, v7, 0xff

    rem-int/lit8 v8, v0, 0x8

    aget v8, v2, v8

    xor-int/2addr v8, v7

    add-int/lit8 v9, v0, 0x8

    and-int/lit16 v8, v8, 0xff

    int-to-byte v8, v8

    aput-byte v8, v6, v9

    xor-int/2addr v1, v7

    add-int/lit8 v0, v0, 0x1

    goto/16 :goto_0

    :cond_1
    add-int/lit8 v0, v5, 0x8

    const/4 v3, 0x0

    aget v3, v2, v3

    xor-int/2addr v3, v1

    and-int/lit16 v3, v3, 0xff

    int-to-byte v3, v3

    aput-byte v3, v6, v0

    add-int/lit8 v0, v5, 0x8

    add-int/lit8 v0, v0, 0x1

    const/4 v3, 0x1

    aget v2, v2, v3

    xor-int/2addr v1, v2

    and-int/lit16 v1, v1, 0xff

    int-to-byte v1, v1

    aput-byte v1, v6, v0

    return-object v6
.end method
