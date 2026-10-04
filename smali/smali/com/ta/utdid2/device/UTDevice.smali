.class public Lcom/ta/utdid2/device/UTDevice;
.super Ljava/lang/Object;


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static getUtdid(Landroid/content/Context;)Ljava/lang/String;
    .locals 2

    invoke-static {p0}, Lcom/ta/utdid2/device/b;->a(Landroid/content/Context;)Lcom/ta/utdid2/device/a;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object v1, v0, Lcom/ta/utdid2/device/a;->d:Ljava/lang/String;

    invoke-static {v1}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    :cond_0
    const-string v0, "ffffffffffffffffffffffff"

    :goto_0
    return-object v0

    :cond_1
    iget-object v0, v0, Lcom/ta/utdid2/device/a;->d:Ljava/lang/String;

    goto :goto_0
.end method
