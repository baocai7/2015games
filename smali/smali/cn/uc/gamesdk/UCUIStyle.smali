.class public final enum Lcn/uc/gamesdk/UCUIStyle;
.super Ljava/lang/Enum;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum",
        "<",
        "Lcn/uc/gamesdk/UCUIStyle;",
        ">;"
    }
.end annotation


# static fields
.field public static final enum SIMPLE:Lcn/uc/gamesdk/UCUIStyle;

.field public static final enum STANDARD:Lcn/uc/gamesdk/UCUIStyle;

.field private static final synthetic a:[Lcn/uc/gamesdk/UCUIStyle;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    const/4 v3, 0x1

    const/4 v2, 0x0

    new-instance v0, Lcn/uc/gamesdk/UCUIStyle;

    const-string v1, "STANDARD"

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/UCUIStyle;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/UCUIStyle;->STANDARD:Lcn/uc/gamesdk/UCUIStyle;

    new-instance v0, Lcn/uc/gamesdk/UCUIStyle;

    const-string v1, "SIMPLE"

    invoke-direct {v0, v1, v3}, Lcn/uc/gamesdk/UCUIStyle;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/UCUIStyle;->SIMPLE:Lcn/uc/gamesdk/UCUIStyle;

    const/4 v0, 0x2

    new-array v0, v0, [Lcn/uc/gamesdk/UCUIStyle;

    sget-object v1, Lcn/uc/gamesdk/UCUIStyle;->STANDARD:Lcn/uc/gamesdk/UCUIStyle;

    aput-object v1, v0, v2

    sget-object v1, Lcn/uc/gamesdk/UCUIStyle;->SIMPLE:Lcn/uc/gamesdk/UCUIStyle;

    aput-object v1, v0, v3

    sput-object v0, Lcn/uc/gamesdk/UCUIStyle;->a:[Lcn/uc/gamesdk/UCUIStyle;

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

.method public static a(I)Lcn/uc/gamesdk/UCUIStyle;
    .locals 1

    packed-switch p0, :pswitch_data_0

    sget-object v0, Lcn/uc/gamesdk/UCUIStyle;->STANDARD:Lcn/uc/gamesdk/UCUIStyle;

    :goto_0
    return-object v0

    :pswitch_0
    sget-object v0, Lcn/uc/gamesdk/UCUIStyle;->STANDARD:Lcn/uc/gamesdk/UCUIStyle;

    goto :goto_0

    :pswitch_1
    sget-object v0, Lcn/uc/gamesdk/UCUIStyle;->SIMPLE:Lcn/uc/gamesdk/UCUIStyle;

    goto :goto_0

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method public static valueOf(Ljava/lang/String;)Lcn/uc/gamesdk/UCUIStyle;
    .locals 1

    const-class v0, Lcn/uc/gamesdk/UCUIStyle;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v0

    check-cast v0, Lcn/uc/gamesdk/UCUIStyle;

    return-object v0
.end method

.method public static values()[Lcn/uc/gamesdk/UCUIStyle;
    .locals 1

    sget-object v0, Lcn/uc/gamesdk/UCUIStyle;->a:[Lcn/uc/gamesdk/UCUIStyle;

    invoke-virtual {v0}, [Lcn/uc/gamesdk/UCUIStyle;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcn/uc/gamesdk/UCUIStyle;

    return-object v0
.end method
