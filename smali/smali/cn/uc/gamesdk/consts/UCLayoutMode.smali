.class public final enum Lcn/uc/gamesdk/consts/UCLayoutMode;
.super Ljava/lang/Enum;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum",
        "<",
        "Lcn/uc/gamesdk/consts/UCLayoutMode;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcn/uc/gamesdk/consts/UCLayoutMode;

.field public static final enum DialogStyle:Lcn/uc/gamesdk/consts/UCLayoutMode;

.field public static final enum FullSize:Lcn/uc/gamesdk/consts/UCLayoutMode;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    const/4 v3, 0x1

    const/4 v2, 0x0

    new-instance v0, Lcn/uc/gamesdk/consts/UCLayoutMode;

    const-string v1, "FullSize"

    invoke-direct {v0, v1, v2}, Lcn/uc/gamesdk/consts/UCLayoutMode;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/consts/UCLayoutMode;->FullSize:Lcn/uc/gamesdk/consts/UCLayoutMode;

    new-instance v0, Lcn/uc/gamesdk/consts/UCLayoutMode;

    const-string v1, "DialogStyle"

    invoke-direct {v0, v1, v3}, Lcn/uc/gamesdk/consts/UCLayoutMode;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/gamesdk/consts/UCLayoutMode;->DialogStyle:Lcn/uc/gamesdk/consts/UCLayoutMode;

    const/4 v0, 0x2

    new-array v0, v0, [Lcn/uc/gamesdk/consts/UCLayoutMode;

    sget-object v1, Lcn/uc/gamesdk/consts/UCLayoutMode;->FullSize:Lcn/uc/gamesdk/consts/UCLayoutMode;

    aput-object v1, v0, v2

    sget-object v1, Lcn/uc/gamesdk/consts/UCLayoutMode;->DialogStyle:Lcn/uc/gamesdk/consts/UCLayoutMode;

    aput-object v1, v0, v3

    sput-object v0, Lcn/uc/gamesdk/consts/UCLayoutMode;->$VALUES:[Lcn/uc/gamesdk/consts/UCLayoutMode;

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

.method public static valueOf(Ljava/lang/String;)Lcn/uc/gamesdk/consts/UCLayoutMode;
    .locals 1

    const-class v0, Lcn/uc/gamesdk/consts/UCLayoutMode;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v0

    check-cast v0, Lcn/uc/gamesdk/consts/UCLayoutMode;

    return-object v0
.end method

.method public static values()[Lcn/uc/gamesdk/consts/UCLayoutMode;
    .locals 1

    sget-object v0, Lcn/uc/gamesdk/consts/UCLayoutMode;->$VALUES:[Lcn/uc/gamesdk/consts/UCLayoutMode;

    invoke-virtual {v0}, [Lcn/uc/gamesdk/consts/UCLayoutMode;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcn/uc/gamesdk/consts/UCLayoutMode;

    return-object v0
.end method
