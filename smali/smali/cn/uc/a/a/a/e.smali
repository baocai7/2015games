.class public final enum Lcn/uc/a/a/a/e;
.super Ljava/lang/Enum;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum",
        "<",
        "Lcn/uc/a/a/a/e;",
        ">;"
    }
.end annotation


# static fields
.field public static final enum a:Lcn/uc/a/a/a/e;

.field public static final enum b:Lcn/uc/a/a/a/e;

.field public static final enum c:Lcn/uc/a/a/a/e;

.field public static final enum d:Lcn/uc/a/a/a/e;

.field public static final enum e:Lcn/uc/a/a/a/e;

.field public static final enum f:Lcn/uc/a/a/a/e;

.field public static final enum g:Lcn/uc/a/a/a/e;

.field private static final synthetic h:[Lcn/uc/a/a/a/e;


# direct methods
.method static constructor <clinit>()V
    .locals 8

    const/4 v7, 0x4

    const/4 v6, 0x3

    const/4 v5, 0x2

    const/4 v4, 0x1

    const/4 v3, 0x0

    new-instance v0, Lcn/uc/a/a/a/e;

    const-string v1, "ERROR"

    invoke-direct {v0, v1, v3}, Lcn/uc/a/a/a/e;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/a/a/a/e;->a:Lcn/uc/a/a/a/e;

    new-instance v0, Lcn/uc/a/a/a/e;

    const-string v1, "WARN"

    invoke-direct {v0, v1, v4}, Lcn/uc/a/a/a/e;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/a/a/a/e;->b:Lcn/uc/a/a/a/e;

    new-instance v0, Lcn/uc/a/a/a/e;

    const-string v1, "DEBUG"

    invoke-direct {v0, v1, v5}, Lcn/uc/a/a/a/e;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/a/a/a/e;->c:Lcn/uc/a/a/a/e;

    new-instance v0, Lcn/uc/a/a/a/e;

    const-string v1, "UPDATE"

    invoke-direct {v0, v1, v6}, Lcn/uc/a/a/a/e;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/a/a/a/e;->d:Lcn/uc/a/a/a/e;

    new-instance v0, Lcn/uc/a/a/a/e;

    const-string v1, "STAT"

    invoke-direct {v0, v1, v7}, Lcn/uc/a/a/a/e;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    new-instance v0, Lcn/uc/a/a/a/e;

    const-string v1, "INFO"

    const/4 v2, 0x5

    invoke-direct {v0, v1, v2}, Lcn/uc/a/a/a/e;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/a/a/a/e;->f:Lcn/uc/a/a/a/e;

    new-instance v0, Lcn/uc/a/a/a/e;

    const-string v1, "ACTION"

    const/4 v2, 0x6

    invoke-direct {v0, v1, v2}, Lcn/uc/a/a/a/e;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcn/uc/a/a/a/e;->g:Lcn/uc/a/a/a/e;

    const/4 v0, 0x7

    new-array v0, v0, [Lcn/uc/a/a/a/e;

    sget-object v1, Lcn/uc/a/a/a/e;->a:Lcn/uc/a/a/a/e;

    aput-object v1, v0, v3

    sget-object v1, Lcn/uc/a/a/a/e;->b:Lcn/uc/a/a/a/e;

    aput-object v1, v0, v4

    sget-object v1, Lcn/uc/a/a/a/e;->c:Lcn/uc/a/a/a/e;

    aput-object v1, v0, v5

    sget-object v1, Lcn/uc/a/a/a/e;->d:Lcn/uc/a/a/a/e;

    aput-object v1, v0, v6

    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    aput-object v1, v0, v7

    const/4 v1, 0x5

    sget-object v2, Lcn/uc/a/a/a/e;->f:Lcn/uc/a/a/a/e;

    aput-object v2, v0, v1

    const/4 v1, 0x6

    sget-object v2, Lcn/uc/a/a/a/e;->g:Lcn/uc/a/a/a/e;

    aput-object v2, v0, v1

    sput-object v0, Lcn/uc/a/a/a/e;->h:[Lcn/uc/a/a/a/e;

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

.method public static valueOf(Ljava/lang/String;)Lcn/uc/a/a/a/e;
    .locals 1

    const-class v0, Lcn/uc/a/a/a/e;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object v0

    check-cast v0, Lcn/uc/a/a/a/e;

    return-object v0
.end method

.method public static values()[Lcn/uc/a/a/a/e;
    .locals 1

    sget-object v0, Lcn/uc/a/a/a/e;->h:[Lcn/uc/a/a/a/e;

    invoke-virtual {v0}, [Lcn/uc/a/a/a/e;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcn/uc/a/a/a/e;

    return-object v0
.end method
