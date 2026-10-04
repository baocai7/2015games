.class public final enum Lcn/uc/gamesdk/UCOrientation;
.super Ljava/lang/Enum;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum",
        "<",
        "Lcn/uc/gamesdk/UCOrientation;",
        ">;"
    }
.end annotation


# static fields
.field public static final enum LANDSCAPE:Lcn/uc/gamesdk/UCOrientation;

.field public static final enum PORTRAIT:Lcn/uc/gamesdk/UCOrientation;

.field private static final synthetic a:[Lcn/uc/gamesdk/UCOrientation;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    const/4 v3, 0x1

    const/4 v2, 0x0

    new-instance v0, Lcn/uc/gamesdk/UCOrientation;

    const-string v1, "PORTRAIT"

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/UCOrientation;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/UCOrientation;->PORTRAIT:Lcn/uc/gamesdk/UCOrientation;

    new-instance v0, Lcn/uc/gamesdk/UCOrientation;

    const-string v1, "LANDSCAPE"

    invoke-direct {v0, v1, v3}, Lcn/uc/gamesdk/UCOrientation;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/UCOrientation;->LANDSCAPE:Lcn/uc/gamesdk/UCOrientation;

    const/4 v0, 0x2

    new-array v0, v0, [Lcn/uc/gamesdk/UCOrientation;

    sget-object v1, Lcn/uc/gamesdk/UCOrientation;->PORTRAIT:Lcn/uc/gamesdk/UCOrientation;

    aput-object v1, v0, v2

    sget-object v1, Lcn/uc/gamesdk/UCOrientation;->LANDSCAPE:Lcn/uc/gamesdk/UCOrientation;

    aput-object v1, v0, v3

    sput-object v0, Lcn/uc/gamesdk/UCOrientation;->a:[Lcn/uc/gamesdk/UCOrientation;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static a(I)Lcn/uc/gamesdk/UCOrientation;
    .locals 1

    packed-switch p0, :pswitch_data_0

    sget-object v0, Lcn/uc/gamesdk/UCOrientation;->PORTRAIT:Lcn/uc/gamesdk/UCOrientation;

    :goto_0
    return-object v0

    :pswitch_0
    sget-object v0, Lcn/uc/gamesdk/UCOrientation;->LANDSCAPE:Lcn/uc/gamesdk/UCOrientation;

    goto :goto_0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
    .end packed-switch
.end method

.method public static valueOf(Ljava/lang/String;)Lcn/uc/gamesdk/UCOrientation;
    .locals 1

    const-class v0, Lcn/uc/gamesdk/UCOrientation;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v0

    check-cast v0, Lcn/uc/gamesdk/UCOrientation;

    return-object v0
.end method

.method public static values()[Lcn/uc/gamesdk/UCOrientation;
    .locals 1

    sget-object v0, Lcn/uc/gamesdk/UCOrientation;->a:[Lcn/uc/gamesdk/UCOrientation;

    invoke-virtual {v0}, [Lcn/uc/gamesdk/UCOrientation;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcn/uc/gamesdk/UCOrientation;

    return-object v0
.end method
