.class public final enum Lcn/uc/a/a/a/h;
.super Ljava/lang/Enum;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum",
        "<",
        "Lcn/uc/a/a/a/h;",
        ">;"
    }
.end annotation


# static fields
.field public static final enum a:Lcn/uc/a/a/a/h;

.field public static final enum b:Lcn/uc/a/a/a/h;

.field private static final synthetic c:[Lcn/uc/a/a/a/h;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    const/4 v3, 0x1

    const/4 v2, 0x0

    new-instance v0, Lcn/uc/a/a/a/h;

    const-string v1, "INTERNAL"

    invoke-direct {v0, v1, v2}, Lcn/uc/a/a/a/h;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/a/a/a/h;->a:Lcn/uc/a/a/a/h;

    new-instance v0, Lcn/uc/a/a/a/h;

    const-string v1, "SDCARD"

    invoke-direct {v0, v1, v3}, Lcn/uc/a/a/a/h;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/a/a/a/h;->b:Lcn/uc/a/a/a/h;

    const/4 v0, 0x2

    new-array v0, v0, [Lcn/uc/a/a/a/h;

    sget-object v1, Lcn/uc/a/a/a/h;->a:Lcn/uc/a/a/a/h;

    aput-object v1, v0, v2

    sget-object v1, Lcn/uc/a/a/a/h;->b:Lcn/uc/a/a/a/h;

    aput-object v1, v0, v3

    sput-object v0, Lcn/uc/a/a/a/h;->c:[Lcn/uc/a/a/a/h;

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

.method public static valueOf(Ljava/lang/String;)Lcn/uc/a/a/a/h;
    .locals 1

    const-class v0, Lcn/uc/a/a/a/h;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v0

    check-cast v0, Lcn/uc/a/a/a/h;

    return-object v0
.end method

.method public static values()[Lcn/uc/a/a/a/h;
    .locals 1

    sget-object v0, Lcn/uc/a/a/a/h;->c:[Lcn/uc/a/a/a/h;

    invoke-virtual {v0}, [Lcn/uc/a/a/a/h;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcn/uc/a/a/a/h;

    return-object v0
.end method
