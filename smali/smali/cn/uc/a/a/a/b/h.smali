.class public Lcn/uc/a/a/a/b/h;
.super Ljava/lang/Object;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcn/uc/a/a/a/b/h$1;
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a()Ljava/lang/String;
    .locals 2

    invoke-static {}, Lcn/uc/a/a/a/b/h;->c()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/a;->a()Landroid/content/Context;

    move-result-object v0

    sget-object v1, Lcn/uc/a/a/a/h;->b:Lcn/uc/a/a/a/h;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/b/h;->a(Landroid/content/Context;Lcn/uc/a/a/a/h;)Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :cond_0
    invoke-static {}, Lcn/uc/a/a/a/a;->a()Landroid/content/Context;

    move-result-object v0

    sget-object v1, Lcn/uc/a/a/a/h;->a:Lcn/uc/a/a/a/h;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/b/h;->a(Landroid/content/Context;Lcn/uc/a/a/a/h;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0
.end method

.method private static a(Landroid/content/Context;)Ljava/lang/String;
    .locals 1

    const-string v0, ""

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v0

    invoke-virtual {v0}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v0

    :cond_0
    return-object v0
.end method

.method public static a(Landroid/content/Context;Lcn/uc/a/a/a/h;)Ljava/lang/String;
    .locals 2

    const-string v0, ""

    sget-object v0, Lcn/uc/a/a/a/b/h$1;->a:[I

    invoke-virtual {p1}, Lcn/uc/a/a/a/h;->ordinal()I

    move-result v1

    aget v0, v0, v1

    packed-switch v0, :pswitch_data_0

    :goto_0
    invoke-static {}, Lcn/uc/a/a/a/b/h;->c()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/b/h;->b()Ljava/lang/String;

    move-result-object v0

    :goto_1
    invoke-static {v0}, Lcn/uc/a/a/a/b/c;->a(Ljava/lang/String;)V

    return-object v0

    :pswitch_0
    invoke-static {p0}, Lcn/uc/a/a/a/b/h;->a(Landroid/content/Context;)Ljava/lang/String;

    :pswitch_1
    invoke-static {}, Lcn/uc/a/a/a/b/h;->b()Ljava/lang/String;

    goto :goto_0

    :cond_0
    invoke-static {p0}, Lcn/uc/a/a/a/b/h;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    goto :goto_1

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method public static b()Ljava/lang/String;
    .locals 4

    const-string v0, ""

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v1

    invoke-static {}, Landroid/os/Environment;->getExternalStorageState()Ljava/lang/String;

    move-result-object v2

    const-string v3, "mounted"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v1}, Ljava/io/File;->canWrite()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v1}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v0

    :cond_0
    return-object v0
.end method

.method public static c()Z
    .locals 3

    invoke-static {}, Landroid/os/Environment;->getExternalStorageDirectory()Ljava/io/File;

    move-result-object v0

    invoke-static {}, Landroid/os/Environment;->getExternalStorageState()Ljava/lang/String;

    move-result-object v1

    const-string v2, "mounted"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {v0}, Ljava/io/File;->canWrite()Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method
