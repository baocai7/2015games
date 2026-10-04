.class public final enum Lcn/uc/gamesdk/UCLoginFaceType;
.super Ljava/lang/Enum;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum",
        "<",
        "Lcn/uc/gamesdk/UCLoginFaceType;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcn/uc/gamesdk/UCLoginFaceType;

.field public static final enum DEFAULT:Lcn/uc/gamesdk/UCLoginFaceType;

.field public static final enum USE_STANDARD:Lcn/uc/gamesdk/UCLoginFaceType;

.field public static final enum USE_WIDGET:Lcn/uc/gamesdk/UCLoginFaceType;


# direct methods
.method static constructor <clinit>()V
    .locals 5

    const/4 v4, 0x2

    const/4 v3, 0x1

    const/4 v2, 0x0

    new-instance v0, Lcn/uc/gamesdk/UCLoginFaceType;

    const-string v1, "DEFAULT"

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/UCLoginFaceType;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/UCLoginFaceType;->DEFAULT:Lcn/uc/gamesdk/UCLoginFaceType;

    new-instance v0, Lcn/uc/gamesdk/UCLoginFaceType;

    const-string v1, "USE_WIDGET"

    invoke-direct {v0, v1, v3}, Lcn/uc/gamesdk/UCLoginFaceType;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/UCLoginFaceType;->USE_WIDGET:Lcn/uc/gamesdk/UCLoginFaceType;

    new-instance v0, Lcn/uc/gamesdk/UCLoginFaceType;

    const-string v1, "USE_STANDARD"

    invoke-direct {v0, v1, v4}, Lcn/uc/gamesdk/UCLoginFaceType;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/UCLoginFaceType;->USE_STANDARD:Lcn/uc/gamesdk/UCLoginFaceType;

    const/4 v0, 0x3

    new-array v0, v0, [Lcn/uc/gamesdk/UCLoginFaceType;

    sget-object v1, Lcn/uc/gamesdk/UCLoginFaceType;->DEFAULT:Lcn/uc/gamesdk/UCLoginFaceType;

    aput-object v1, v0, v2

    sget-object v1, Lcn/uc/gamesdk/UCLoginFaceType;->USE_WIDGET:Lcn/uc/gamesdk/UCLoginFaceType;

    aput-object v1, v0, v3

    sget-object v1, Lcn/uc/gamesdk/UCLoginFaceType;->USE_STANDARD:Lcn/uc/gamesdk/UCLoginFaceType;

    aput-object v1, v0, v4

    sput-object v0, Lcn/uc/gamesdk/UCLoginFaceType;->$VALUES:[Lcn/uc/gamesdk/UCLoginFaceType;

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

.method public static valueOf(I)Lcn/uc/gamesdk/UCLoginFaceType;
    .locals 1

    packed-switch p0, :pswitch_data_0

    sget-object v0, Lcn/uc/gamesdk/UCLoginFaceType;->DEFAULT:Lcn/uc/gamesdk/UCLoginFaceType;

    :goto_0
    return-object v0

    :pswitch_0
    sget-object v0, Lcn/uc/gamesdk/UCLoginFaceType;->USE_WIDGET:Lcn/uc/gamesdk/UCLoginFaceType;

    goto :goto_0

    :pswitch_1
    sget-object v0, Lcn/uc/gamesdk/UCLoginFaceType;->USE_STANDARD:Lcn/uc/gamesdk/UCLoginFaceType;

    goto :goto_0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method public static valueOf(Ljava/lang/String;)Lcn/uc/gamesdk/UCLoginFaceType;
    .locals 1

    const-class v0, Lcn/uc/gamesdk/UCLoginFaceType;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v0

    check-cast v0, Lcn/uc/gamesdk/UCLoginFaceType;

    return-object v0
.end method

.method public static values()[Lcn/uc/gamesdk/UCLoginFaceType;
    .locals 1

    sget-object v0, Lcn/uc/gamesdk/UCLoginFaceType;->$VALUES:[Lcn/uc/gamesdk/UCLoginFaceType;

    invoke-virtual {v0}, [Lcn/uc/gamesdk/UCLoginFaceType;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcn/uc/gamesdk/UCLoginFaceType;

    return-object v0
.end method
