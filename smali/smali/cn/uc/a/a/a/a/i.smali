.class public Lcn/uc/a/a/a/a/i;
.super Landroid/os/AsyncTask;


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroid/os/AsyncTask",
        "<",
        "Ljava/lang/Object;",
        "Ljava/lang/Void;",
        "Lcn/uc/a/a/a/a/j;",
        ">;"
    }
.end annotation


# instance fields
.field private a:Lcn/uc/a/a/a/a/h;

.field private b:Ljava/lang/String;

.field private c:Ljava/lang/String;

.field private d:Lcn/uc/a/a/a/a/c;

.field private e:Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcn/uc/a/a/a/a/h;Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/a/c;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Landroid/os/AsyncTask;-><init>()V

    iput-object p1, p0, Lcn/uc/a/a/a/a/i;->a:Lcn/uc/a/a/a/a/h;

    iput-object p2, p0, Lcn/uc/a/a/a/a/i;->b:Ljava/lang/String;

    iput-object p3, p0, Lcn/uc/a/a/a/a/i;->c:Ljava/lang/String;

    iput-object p4, p0, Lcn/uc/a/a/a/a/i;->d:Lcn/uc/a/a/a/a/c;

    iput-object p5, p0, Lcn/uc/a/a/a/a/i;->e:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method protected varargs a([Ljava/lang/Object;)Lcn/uc/a/a/a/a/j;
    .locals 4

    iget-object v0, p0, Lcn/uc/a/a/a/a/i;->b:Ljava/lang/String;

    iget-object v1, p0, Lcn/uc/a/a/a/a/i;->c:Ljava/lang/String;

    iget-object v2, p0, Lcn/uc/a/a/a/a/i;->d:Lcn/uc/a/a/a/a/c;

    iget-object v3, p0, Lcn/uc/a/a/a/a/i;->e:Ljava/lang/String;

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/a/g;->a(Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/a/c;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    return-object v0
.end method

.method protected a(Lcn/uc/a/a/a/a/j;)V
    .locals 1

    invoke-super {p0, p1}, Landroid/os/AsyncTask;->onPostExecute(Ljava/lang/Object;)V

    iget-object v0, p0, Lcn/uc/a/a/a/a/i;->a:Lcn/uc/a/a/a/a/h;

    invoke-interface {v0, p1}, Lcn/uc/a/a/a/a/h;->a(Lcn/uc/a/a/a/a/j;)V

    return-void
.end method

.method protected synthetic doInBackground([Ljava/lang/Object;)Ljava/lang/Object;
    .locals 1

    invoke-virtual {p0, p1}, Lcn/uc/a/a/a/a/i;->a([Ljava/lang/Object;)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    return-object v0
.end method

.method protected synthetic onPostExecute(Ljava/lang/Object;)V
    .locals 0

    check-cast p1, Lcn/uc/a/a/a/a/j;

    invoke-virtual {p0, p1}, Lcn/uc/a/a/a/a/i;->a(Lcn/uc/a/a/a/a/j;)V

    return-void
.end method
