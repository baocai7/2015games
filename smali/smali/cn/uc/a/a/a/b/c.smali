.class public Lcn/uc/a/a/a/b/c;
.super Ljava/lang/Object;


# static fields
.field public static final a:Ljava/lang/String; = "DebugUtil"

.field public static b:Z


# direct methods
.method static constructor <clinit>()V
    .locals 1

    const/4 v0, 0x1

    sput-boolean v0, Lcn/uc/a/a/a/b/c;->b:Z

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a(Ljava/lang/String;)V
    .locals 1

    sget-boolean v0, Lcn/uc/a/a/a/b/c;->b:Z

    if-eqz v0, :cond_0

    const-string v0, "DebugUtil"

    invoke-static {v0, p0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-void
.end method
