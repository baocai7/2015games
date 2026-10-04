.class public final enum Lcn/uc/gamesdk/UCLogLevel;
.super Ljava/lang/Enum;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum",
        "<",
        "Lcn/uc/gamesdk/UCLogLevel;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcn/uc/gamesdk/UCLogLevel;

.field public static final enum DEBUG:Lcn/uc/gamesdk/UCLogLevel;

.field public static final enum ERROR:Lcn/uc/gamesdk/UCLogLevel;

.field public static final enum WARN:Lcn/uc/gamesdk/UCLogLevel;


# direct methods
.method static constructor <clinit>()V
    .locals 5

    const/4 v4, 0x2

    const/4 v3, 0x1

    const/4 v2, 0x0

    new-instance v0, Lcn/uc/gamesdk/UCLogLevel;

    const-string v1, "ERROR"

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/UCLogLevel;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/UCLogLevel;->ERROR:Lcn/uc/gamesdk/UCLogLevel;

    new-instance v0, Lcn/uc/gamesdk/UCLogLevel;

    const-string v1, "WARN"

    invoke-direct {v0, v1, v3}, Lcn/uc/gamesdk/UCLogLevel;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/UCLogLevel;->WARN:Lcn/uc/gamesdk/UCLogLevel;

    new-instance v0, Lcn/uc/gamesdk/UCLogLevel;

    const-string v1, "DEBUG"

    invoke-direct {v0, v1, v4}, Lcn/uc/gamesdk/UCLogLevel;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/UCLogLevel;->DEBUG:Lcn/uc/gamesdk/UCLogLevel;

    const/4 v0, 0x3

    new-array v0, v0, [Lcn/uc/gamesdk/UCLogLevel;

    sget-object v1, Lcn/uc/gamesdk/UCLogLevel;->ERROR:Lcn/uc/gamesdk/UCLogLevel;

    aput-object v1, v0, v2

    sget-object v1, Lcn/uc/gamesdk/UCLogLevel;->WARN:Lcn/uc/gamesdk/UCLogLevel;

    aput-object v1, v0, v3

    sget-object v1, Lcn/uc/gamesdk/UCLogLevel;->DEBUG:Lcn/uc/gamesdk/UCLogLevel;

    aput-object v1, v0, v4

    sput-object v0, Lcn/uc/gamesdk/UCLogLevel;->$VALUES:[Lcn/uc/gamesdk/UCLogLevel;

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

.method public static fromValue(I)Lcn/uc/gamesdk/UCLogLevel;
    .locals 1

    packed-switch p0, :pswitch_data_0

    sget-object v0, Lcn/uc/gamesdk/UCLogLevel;->ERROR:Lcn/uc/gamesdk/UCLogLevel;

    :goto_0
    return-object v0

    :pswitch_0
    sget-object v0, Lcn/uc/gamesdk/UCLogLevel;->WARN:Lcn/uc/gamesdk/UCLogLevel;

    goto :goto_0

    :pswitch_1
    sget-object v0, Lcn/uc/gamesdk/UCLogLevel;->DEBUG:Lcn/uc/gamesdk/UCLogLevel;

    goto :goto_0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method public static valueOf(Ljava/lang/String;)Lcn/uc/gamesdk/UCLogLevel;
    .locals 1

    const-class v0, Lcn/uc/gamesdk/UCLogLevel;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v0

    check-cast v0, Lcn/uc/gamesdk/UCLogLevel;

    return-object v0
.end method

.method public static values()[Lcn/uc/gamesdk/UCLogLevel;
    .locals 1

    sget-object v0, Lcn/uc/gamesdk/UCLogLevel;->$VALUES:[Lcn/uc/gamesdk/UCLogLevel;

    invoke-virtual {v0}, [Lcn/uc/gamesdk/UCLogLevel;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcn/uc/gamesdk/UCLogLevel;

    return-object v0
.end method
