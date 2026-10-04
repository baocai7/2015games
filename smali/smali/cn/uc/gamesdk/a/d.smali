.class public Lcn/uc/gamesdk/a/d;
.super Ljava/lang/Object;


# static fields
.field public static a:Landroid/os/Handler; = null

.field public static b:Landroid/content/Context; = null

.field public static c:Lcn/uc/gamesdk/info/GameParamInfo; = null

.field public static d:Ljava/util/HashMap; = null
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation
.end field

.field public static e:Ljava/util/ArrayList; = null
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field public static f:I = 0x0

.field public static g:Z = false

.field public static h:Lcn/uc/gamesdk/UCOrientation; = null

.field private static final i:Ljava/lang/String; = "SharedVars"


# direct methods
.method static constructor <clinit>()V
    .locals 4

    const/4 v3, 0x0

    const/4 v2, 0x0

    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcn/uc/gamesdk/a/d;->a:Landroid/os/Handler;

    sput-object v3, Lcn/uc/gamesdk/a/d;->b:Landroid/content/Context;

    sput-object v3, Lcn/uc/gamesdk/a/d;->c:Lcn/uc/gamesdk/info/GameParamInfo;

    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcn/uc/gamesdk/a/d;->d:Ljava/util/HashMap;

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sput-object v0, Lcn/uc/gamesdk/a/d;->e:Ljava/util/ArrayList;

    sput v2, Lcn/uc/gamesdk/a/d;->f:I

    sput-boolean v2, Lcn/uc/gamesdk/a/d;->g:Z

    sget-object v0, Lcn/uc/gamesdk/UCOrientation;->PORTRAIT:Lcn/uc/gamesdk/UCOrientation;

    sput-object v0, Lcn/uc/gamesdk/a/d;->h:Lcn/uc/gamesdk/UCOrientation;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
